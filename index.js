const express = require('express');
const bodyParser = require('body-parser');
const cryptoRandomString = require('crypto-random-string');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const verify = require('./verifyToken');
const app = express();
var mysql = require('mysql');
var cors = require('cors');

const TAJNA_SVEMIRA = "TAJNA_SVEMIRA";

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));
app.use(cors());

var con = mysql.createConnection({
    host: "localhost",
    port: 3306,
    user: "root",
    password: "",
    database: "test"
});


con.connect();


app.post('/register', async function(req, res) {
    var user = req.body.username;
    var pass = req.body.password;
    var email = req.body.email;

    var salt = await bcrypt.genSalt(10);
    var hashPass = await bcrypt.hash(pass, salt);

    var query = "insert into korisnik(username,password,email,privilegija,banovan) values("+con.escape(user)+",'"+hashPass+"',"+con.escape(email)+",1,0);";

    con.query(query, function(err, result){
        if(err)
        {
            res.status(500).send(err.message);
        }
        else
        {
            res.status(200).send("Uspješna registracija");
        }
    });
});


app.post('/login', async function (req, res){
    var user = req.body.username;
    var pass = req.body.password;
    
    var query = "select id, password, privilegija from korisnik where username = " + con.escape(user) + ";";
    //var query = "select id from korisnik;";
    con.query(query, async function(err, result){
        if(err)
        {
            return res.status(500).send("Greška na serveru");
        }
        if(!result[0])
        {
            return res.status(404).send("Ne postoji korisnik");
        }
        else
        {
            const ValidPass = await bcrypt.compare(pass, result[0].password);
            if(!ValidPass)
            {
                return res.status(401).send("Pogrešna šifra "+pass);
            }
            else
            {               
                const token = jwt.sign({id: result[0].id, privilegija: result[0].privilegija}, TAJNA_SVEMIRA);
                var sad = new Date();
                var datumIsteka = new Date(sad.getTime() + 15*60000).toISOString().slice(0,19).replace('T', ' ');
                var query2 = "insert into sesija(id_korisnik, token, datum_isteka) values('"+ result[0].id +"', '"+token+"','"+datumIsteka+"')";
                con.query(query2, async function(err, result){
                    if(err)
                    {
                        return res.status(500).send("Greška na serveru");
                    }
                });
                return res.status(200).json({"auth" : token, privilegija: result[0].privilegija});
            }
        }
    });
});


app.post('/dodajZadatak', verify, async function(req, res){
    const token = req.header('auth-token'); 
    const verified = jwt.verify(token, TAJNA_SVEMIRA);
    var postavka = req.body.postavka;
    var zagonetka = req.body.zagonetka;
    var rjesenje = req.body.rjesenje;
    var hint = req.body.hint;
    var kategorija = req.body.kategorija;
    var idKorisnika = verified.id;
    var privilegija = verified.privilegija;

    if(privilegija < 2)
    {
        console.log(privilegija);
        return res.status(401).send("Access Denied");
    }

    if(!postavka || !zagonetka || !rjesenje || !hint || kategorija==null)
    {
        return res.status(500).send("Pogrešan format zahtjeva");
    }

    try
    {
        var query = "select count(*) as ima from kategorija where id = " + con.escape(kategorija) + ";"
        con.query(query, async function(err, result){
            if(err)
            {
                return res.status(500).send("Greška na serveru");
            }
            else
            {
                if(result[0].ima == 0)
                {
                    return res.status(404).send("Ne postoji kategorija");
                }
                var datum =  new Date().toISOString().slice(0,19).replace('T', ' ');
                var query2 = "insert into zadatak(id_korisnik, postavka, zagonetka, rjesenje, hint, obrisan, datum_kreiranja, zadnja_promjena, kategorija) values";
                query2 += "("+idKorisnika+","+con.escape(postavka)+","+con.escape(zagonetka)+","+con.escape(rjesenje)+","+con.escape(hint);
                query2 += ", 0,'"+datum+"','"+datum+"', "+con.escape(kategorija)+");"
               
                con.query(query2, async function(err, result){
                    if(err)
                    {
                        return res.status(500).send("Greška na serveru");
                    }
                    else
                    {
                        return res.status(200).json({rez : result.insertId});
                    }
                });

            }
        });
    }
    catch(err)
    {
        return res.status(500).send("Greška na serveru");
    }

});

app.post('/obrisiZadatak', verify, async function(req, res){
    var idZadatka = req.body.idZadatka;
    const token = req.header('auth-token'); 
    const verified = jwt.verify(token, TAJNA_SVEMIRA);

    if(verified.privilegija < 2)
    {
        return res.status(401).send("Access Denied");
    }

    if(!idZadatka)
    {
        return res.status(404).send("Pogrešan zadatak");
    }


    try
    {
        const verified = jwt.verify(req.header('auth-token'), TAJNA_SVEMIRA);
        var korisnik = verified.id;
        var query = "update zadatak set obrisan = 1 where id = " + con.escape(idZadatka);
        con.query(query, async function(err, result){
            if(err)
            {
                return res.status(500).send(err.message);
            }
            else
            {
                return res.status(200).send("Obrisan zadatak");
            }
        });

    }
    catch(err)
    {
        return res.status(500).send("Greška na serveru");
    }
    

});

app.post('/editujZadatak', verify, async function(req, res){
    var postavka = req.body.postavka;
    var zagonetka = req.body.zagonetka;
    var rjesenje = req.body.rjesenje;
    var hint = req.body.hint;
    var idZadatka = req.body.idZadatka;

    const token = req.header('auth-token'); 
    const verified = jwt.verify(token, TAJNA_SVEMIRA);

    if(!postavka || !zagonetka || !rjesenje || !hint || !idZadatka)
    {
        return res.status(500).send("Pogrešan format zahtjeva");
    }

    var idKorisnika = verified.id;
    var privilegija = verified.privilegija;

    if(privilegija < 2)
    {
        console.log(privilegija);
        return res.status(401).send("Access Denied");
    }

    try
    {
        var datum =  new Date().toISOString().slice(0,19).replace('T', ' ');
        var query = `update zadatak set postavka = ${con.escape(postavka)}, zagonetka = ${con.escape(zagonetka)}, rjesenje = ${con.escape(rjesenje)}, hint = ${con.escape(hint)},
        obrisan = 0, zadnja_promjena = '${datum}' where id = ${con.escape(idZadatka)};`;
        con.query(query, async function(err, result){
            if(err)
            {
                return res.status(500).send(err.message);
            }
            else
            {
                return res.status(200).send("Editovan zadatak!");
            }
        });
    }
    catch(err)
    {
        return res.status(500).send(err.message);
    }

});

app.get('/zadatak/:idZadatka', verify ,async function(req, res){
    try
    {
        var idZadatka = con.escape(req.params.idZadatka);
        var query = `select * from zadatak where id = ${idZadatka};`
        con.query(query, async function(err, result){
            if(!result[0])
            {        
                return res.status(404).send("Pogrešan id");
            }
            else
            {
                return res.status(200).send(result);
            }

        });
    }
    catch(err)
    {
        return res.status(500).send(err.message);
    }

});

app.post('/dodajKategoriju', verify, async function(req, res){
    var naziv = con.escape(req.body.naziv);
    var nadkategorija = con.escape(req.body.idKategorije);

    if(!naziv)
    {
        return res.status(500).send("Pogrešan format zahtjeva");
    }

    try
    {
        var query2 = "select count(*) as broj from kategorija where id = " + nadkategorija + ";";
        con.query(query2, async function(err, result){
            if(result[0].broj == 0 && req.body.idKategorije != null) 
            {
                return res.status(404).send("Ne postoji nadkategorija"); 
            }
            else
            {
                const verified = jwt.verify(req.header('auth-token'), TAJNA_SVEMIRA);
                var kreator = verified.id;
                var query = `insert into kategorija(naziv, id_kategorija) values(${naziv}, ${nadkategorija});`;
                con.query(query, async function(err, result){
                    if(err)
                    {
                        return res.status(500).send(err.message);
                    }
                    else
                    {
                        return res.status(200).send("Dodana kategorija!");
                    }
                });
            }
        });
    }
    catch(err)
    {
        return res.status(500).send("Greška na serveru");
    }

});

app.post('/obrisiKategoriju', verify , async function(req, res){

    var idKategorije = con.escape(req.body.idKategorije);

    if(!req.body.idKategorije)
    {
        return res.status(500).send("Pogrešan format zahtjeva");
    }

    try
    {
        var query = "delete from kategorija where id = " + idKategorije + " or id_kategorija = " + idKategorije + ";";
        con.query(query, async function(err, result){
            if(err)
            {
                return res.status(500).send(err.message);
            }
            else
            {
                return res.status(200).send("Obrisana kategorija!");
            }
        });
    }
    catch(err)
    {
        return res.status(500).send("Greška na serveru");
    }



});


app.get('/dajKategorije', async function(req, res){
    try
    {
        var query = "select id, naziv, nadkategorija from kategorija;";
        con.query(query, async function(err, result){
            if(err)
            {
                return res.status(500).send(err.message);
            }
            else
            {
                let kategorije = [];
                for(let i=0; i<result.length; i++)
                {
                    if(result[i].nadkategorija==null)
                    {
                        let objekt = 
                        {
                            id: result[i].id,
                            naziv: result[i].naziv,
                            podkategorije: []
                        };
                        for(let j=0; j<result.length; j++)
                        {
                            if(result[j].nadkategorija == result[i].id)
                            {
                                objekt.podkategorije.push({
                                    id:result[j].id,
                                    naziv:result[j].naziv
                                });
                            }
                        }
                        kategorije.push(objekt);
                    }
                   
                }
                res.status(200).json(kategorije);
            }
        });
    }
    catch(err)
    {
        return res.status(500).send("Greška na serveru");
    }
});


app.get('/dajZadatke/:idKategorije/:stranica', async function(req, res){
    var idKategorije = req.params.idKategorije;
    var stranica = req.params.stranica;  
    try
    {
        var query = "select nadkategorija from kategorija where id=" + con.escape(req.params.idKategorije)+";";
        con.query(query, async function(err, result){
            if(err)
            {
                return res.status(500).send("Greška na serveru");
            }
            else
            {
                if(result[0].nadkategorija != null)
                {
                    var query2 = "select id, id_korisnik, postavka, zagonetka, rjesenje, hint, kategorija from zadatak";
                    query2 += " where kategorija =" + idKategorije +" and obrisan = 0 order by id desc;"
                    con.query(query2, async function(err, result){
                        if(err) return res.status(500).send("Greška na serveru");
                        else
                        {
                            var maxStranica = parseInt(Math.floor(result.length/10)) + 1;
                            if(stranica > maxStranica)
                            {
                                stranica = maxStranica;
                            }
                            var zadatkevi = [];
                            for(let i=(stranica*10-10); i<stranica*10; i++)
                            {
                                if(i<result.length)
                                zadatkevi.push(result[i]);
                            }
                            var obj = 
                            {
                                max: maxStranica,
                                zadaci: zadatkevi
                            };
                            return res.status(200).json(obj);
                        }
                    });
                    
                }
                else
                {
                    var query2 = "select z.id, z.id_korisnik, z.postavka, z.zagonetka, z.rjesenje, z.hint, z.kategorija from zadatak z, kategorija k";
                    query2 += " where z.kategorija = k.id and k.nadkategorija = "+ idKategorije+" and obrisan=0 order by z.id desc;";
                    con.query(query2, async function(err, result){
                        if(err) return res.status(500).send("Greška na serveru");
                        else
                        {
                            var maxStranica = parseInt(Math.floor(result.length/10)) + 1;
                            if(stranica > maxStranica)
                            {
                                stranica = maxStranica;
                            }
                            var zadatkevi = [];
                            for(let i=(stranica*10-10); i<stranica*10; i++)
                            {
                                if(i<result.length)
                                zadatkevi.push(result[i]);
                            }
                            var obj = 
                            {
                                max: maxStranica,
                                zadaci: zadatkevi
                            };
                            return res.status(200).json(obj);
                        }
                    });
                }
            }
        });
    }
    catch(err)
    {
        return res.status(500).send("Greška na serveru");
    }
});


app.get('/dohvatiZadatak/:id', async function(req, res){
    var query = "select id, id_korisnik, postavka, zagonetka, rjesenje, hint, obrisan, kategorija from zadatak where id="+con.escape(req.params.id)+";";
    con.query(query, async function(err, result){
        if(err) return res.status(500).send("Greška na serveru");
        else
        {
            if(result[0] == null || result[0].obrisan == 1)
            {
                return res.status(401).send("Access Denied");
            }
            else
            return res.status(200).json(result[0]);
        }
    });
});


app.get('/zadatakKategorije/:idZadatka', verify, async function(req, res){
    const token = req.header('auth-token'); 
    var verified = jwt.verify(token, TAJNA_SVEMIRA);
    var idKorisnika = verified.id;
    var idZadatka = req.params.idZadatka;
    var query = "select g.id as idgrupe, g.naziv as nazivgrupe, z.id as idzadatka from grupa g, zadatak z, zapamcenje p where";
    query += " g.id_korisnik = "+ idKorisnika +" and z.id = " + idZadatka + " and ";
    query += " p.id_grupa = g.id and p.id_zadatak = z.id;";
    con.query(query, async function(err, result){
        if(err) return res.status(500).send(err);
        else
        {
            //return res.status(200).json(result);//samo zapamceni, dodati jos sve kat pa onda petljom proci i postaviti varijablu 0/1
            var zapamceneKat = result;
            var query2 = "select g.id as idgrupe, g.naziv as nazivgrupe, z.id as idzadatka from grupa g, zadatak z where";
            query2 += " g.id_korisnik = "+ idKorisnika +" and z.id = " + idZadatka + ";";
            con.query(query2, async function(err, result){
                if(err) return res.status(500).send("Greška na serveru");
                else
                {
                    var sveKategorije = result;
                    var rezultat = [];
                    for(let i=0; i<sveKategorije.length; i++)
                    {
                        var ima = 0;
                        for(let j=0; j<zapamceneKat.length; j++)
                        {
                            if(sveKategorije[i].idgrupe == zapamceneKat[j].idgrupe) ima = 1;
                        }
                        if(ima == 0)
                        {
                            rezultat.push({
                                id: sveKategorije[i].idgrupe,
                                naziv: sveKategorije[i].nazivgrupe,
                                zapamceno: 0
                            });
                        }
                        else
                        {
                            rezultat.push({
                                id: sveKategorije[i].idgrupe,
                                naziv: sveKategorije[i].nazivgrupe,
                                zapamceno: 1
                            });
                        }
                    }
                    return res.status(200).json(rezultat);
                }
            });
        }
    });
});

app.post('/zapamtiZadatak', verify , async function(req, res){
    const token = req.header('auth-token'); 
    const verified = jwt.verify(token, TAJNA_SVEMIRA);
    var idgrupe = req.body.idgrupe;
    var idzadatka = req.body.idzadatka;
    var zapamcenje = req.body.zapamcenje;

    if(zapamcenje > 2 || zapamcenje < 0) return res.status(500).send("Greška na serveru");
    var query;
    if(zapamcenje == 1)
    {
        query = "delete from zapamcenje where id_grupa = "+idgrupe+" and id_zadatak="+idzadatka+";"
    }
    else if(zapamcenje == 0)
    {
        query = "insert into zapamcenje(id_grupa, id_zadatak) values("+idgrupe+","+idzadatka+");";
    }
    con.query(query, async function(err, result){
        if(err) return res.status(500).send("Greška na serveru");
        else
        {
            if(zapamcenje == 0)
            return res.status(200).json({rezultat: 1});
            else
            return res.status(200).json({rezultat: 0});
        }
    });

});

app.post('/dodajGrupu', verify , async function(req, res){
    const token = req.header('auth-token'); 
    const verified = jwt.verify(token, TAJNA_SVEMIRA);
    var naziv = req.body.naziv;

    if(naziv == "") return res.status(400).send("Već ima grupa s tim nazivom");

    var query="select count(*) as ima from grupa where id_korisnik = "+verified.id+" and naziv = "+con.escape(naziv)+";"
    con.query(query, async function(err, result){
        if(err) return res.status(500).send(err);
        else
        {
            if(result[0].ima > 0)
            {
                return res.status(400).send("Već ima grupa sa tim nazivom");
            }
            else
            {
                var query2 = "insert into grupa(naziv, id_korisnik) values("+con.escape(naziv)+", "+verified.id+");"
                con.query(query2, async function(err, result)
                {
                    if(err) return res.status(500).send(err);
                    else
                    {
                        return res.status(200).send("Dodana grupa");
                    }
                });
            }
        }
    });

});


app.get('/dajGrupe', verify , async function(req, res){
    const token = req.header('auth-token'); 
    const verified = jwt.verify(token, TAJNA_SVEMIRA);
    var idKorisnika = verified.id;
    var query = "select id, naziv from grupa where id_korisnik = "+ idKorisnika + ";";
    con.query(query, async function(err, result){
        if(err) return res.status(500).send(err);
        else
        {
            return res.status(200).json(result);
        }
    });

});

app.post('/obrisiGrupu', verify , async function(req, res){
    const token = req.header('auth-token'); 
    const verified = jwt.verify(token, TAJNA_SVEMIRA);
    
    var idGrupe = req.body.idGrupe;
    var idKorisnika = verified.id;

    var query = "select id_korisnik as korisnik from grupa where id="+con.escape(idGrupe)+";";
    con.query(query, async function(err, result){
        if(err) return res.status(500).send(err);
        else
        {
            if(result[0]==null || result[0].korisnik != idKorisnika)
            {
                return res.status(401).send("Access Denied");
            }
            else
            {
                var query2 = "delete from grupa where id = "+con.escape(idGrupe)+";"
                con.query(query2, async function(err, result){
                    if(err) return res.status(500).send(err);
                    else
                    {
                        return res.status(200).json(idGrupe);
                    }
                });
            }
        }
    });



});


app.get('/dajZadatkeGrupe/:idGrupe/:stranica', verify, async function(req, res){
    var idGrupe = req.params.idGrupe;
    var stranica = req.params.stranica;  
    const token = req.header('auth-token'); 
    const verified = jwt.verify(token, TAJNA_SVEMIRA);
    try
    {
        var query = "select id_korisnik as korisnik from grupa where id = "+con.escape(idGrupe)+";"
        con.query(query, async function(err, result){
            if(err)
            {
                return res.status(500).send("Greška na serveru");
            }
            else
            {
                if(result[0] == null || result[0].korisnik != verified.id)
                {
                    return res.status(401).send("Access Denied");
                }
                else
                {
                    var query2 = "select z.id, z.id_korisnik, z.postavka, z.zagonetka, z.rjesenje, z.hint, z.kategorija";
                    query2 += " from zadatak z, zapamcenje p, grupa g where p.id_grupa = g.id and p.id_zadatak = z.id and g.id="
                    query2 += con.escape(idGrupe) + " and z.obrisan = 0";
                    con.query(query2, async function(err, result){
                        if(err) return res.status(500).send(err);
                        else
                        {
                            var maxStranica = parseInt(Math.floor(result.length/10)) + 1;
                            if(stranica > maxStranica)
                            {
                                stranica = maxStranica;
                            }
                            var zadatkevi = [];
                            for(let i=(stranica*10-10); i<stranica*10; i++)
                            {
                                if(i<result.length)
                                zadatkevi.push(result[i]);
                            }
                            var obj = 
                            {
                                max: maxStranica,
                                zadaci: zadatkevi
                            };
                            return res.status(200).json(obj);
                        }
                    });
                    
                }
            }
        });
    }
    catch(err)
    {
        return res.status(500).send("Greška na serveru");
    }
});



app.post('/dummy', verify , async function(req, res){
    const token = req.header('auth-token'); 
    const verified = jwt.verify(token, TAJNA_SVEMIRA);
    res.status(200).send("ID je " + verified.id);

});

app.listen(8080);



//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNTY1OTE0MDcxfQ.pxBbTgrQEPrQGmaCkicLrYqk0FIqWhDEiVIhaYq0ksc
//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOjIsImlhdCI6MTU2NTkxMjQzN30.ZQIiyVw6rSEPr2_dl9THmywKgGEyrr5onB7llafoczg
//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwiaWF0IjoxNTY2MjQxMDE2fQ.ifezyDRbqlFIcMzDNcRq5O_tFRYF8xLVtn0P5yh_XbE
//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwiaWF0IjoxNTY2MjQxMDM4fQ.R6mNkn_WIPP6wZ3omJsLcXXaUoqQ66teFOnzA9xL1_U