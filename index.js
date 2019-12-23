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
    
    var query = "select id, password from korisnik where username = " + con.escape(user) + ";";
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
                const token = jwt.sign({id: result[0].id}, TAJNA_SVEMIRA);
                var sad = new Date();
                var datumIsteka = new Date(sad.getTime() + 15*60000).toISOString().slice(0,19).replace('T', ' ');
                var query2 = "insert into sesija(id_korisnik, token, datum_isteka) values('"+ result[0].id +"', '"+token+"','"+datumIsteka+"')";
                con.query(query2, async function(err, result){
                    if(err)
                    {
                        return res.status(500).send("Greška na serveru");
                    }
                });
                return res.status(200).json({"auth" : token});
            }
        }
    });
});


app.post('/dodajZadatak', verify, async function(req, res){
    var postavka = con.escape(req.body.postavka);
    var zagonetka = con.escape(req.body.zagonetka);
    var rjesenje = con.escape(req.body.rjesenje);
    var hint = con.escape(req.body.hint);

    if(!postavka || !zagonetka || !rjesenje || !hint)
    {
        return res.status(500).send("Pogrešan format zahtjeva");
    }

    try
    {
        const verified = jwt.verify(req.header('auth-token'), TAJNA_SVEMIRA);
        var kreator = verified.id;
        var datum =  new Date().toISOString().slice(0,19).replace('T', ' ');
        var query = `insert into zadatak(id_korisnik, postavka, zagonetka, rjesenje, hint, obrisan, zadnja_promjena) values
        ('${kreator}',${postavka},${zagonetka},${rjesenje},${hint},0,'${datum}')`;
        con.query(query, async function(err, result){
            if(err)
            {
                return res.status(500).send(err.message);
            }
            else
            {
                return res.status(200).send("Dodan zadatak!");
            }
        });
    }
    catch(err)
    {
        return res.status(500).send("Greška na serveru");
    }

});

app.post('/obrisiZadatak', verify, async function(req, res){
    var idZadatka = con.escape(req.body.idZadatka);

    if(!idZadatka)
    {
        return res.status(404).send("Pogrešan zadatak");
    }

    try
    {
        const verified = jwt.verify(req.header('auth-token'), TAJNA_SVEMIRA);
        var korisnik = verified.id;
        var query = "update zadatak set obrisan = 1 where id = " + idZadatka;
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
    var postavka = con.escape(req.body.postavka);
    var zagonetka = con.escape(req.body.zagonetka);
    var rjesenje = con.escape(req.body.rjesenje);
    var hint = con.escape(req.body.hint);
    var idZadatka = con.escape(req.body.idZadatka);

    if(!postavka || !zagonetka || !rjesenje || !hint)
    {
        return res.status(500).send("Pogrešan format zahtjeva");
    }

    try
    {
        const verified = jwt.verify(req.header('auth-token'), TAJNA_SVEMIRA);
        var kreator = verified.id;
        var datum =  new Date().toISOString().slice(0,19).replace('T', ' ');
        var query = `update zadatak set postavka = ${postavka}, zagonetka = ${zagonetka}, rjesenje = ${rjesenje}, hint = ${hint},
        obrisan = 0, zadnja_promjena = '${datum}' where id = ${idZadatka}`;
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


app.get('/zapamtiZadatak/:idZadatka', verify, async function(req, res){
    try
    {
        var idZadatka = con.escape(req.params.idZadatka);
        const token = req.header('auth-token');
        const verified = jwt.verify(token, TAJNA_SVEMIRA);
        var idKorisnika = verified.id;
        var query = `select * from zapamcen_zadatak where id_zadatak = ${idZadatka} and id_korisnik = ${idKorisnika};`;
        con.query(query, async function(err, result){
            if(!result[0])
            {
                var query2 = `insert into zapamcen_zadatak(id_korisnik, id_zadatak) values(${idKorisnika}, ${idZadatka});`;
                con.query(query2, async function(err, result){
                    if(err)
                    {
                        return res.status(500).send(err.message);
                    }

                });
                return res.status(200).send("Zapamćen zadatak");
            }
            else
            {
                return res.status(404).send("Već je zapamćen zadatak");
            }

        });

    }
    catch(err)
    {
        return res.status(500).send(err.message);
    }

});

app.get('/odpamtiZadatak/:idZadatka', verify, async function(req, res){
    try
    {
        var idZadatka = con.escape(req.params.idZadatka);
        const token = req.header('auth-token');
        const verified = jwt.verify(token, TAJNA_SVEMIRA);
        var idKorisnika = verified.id;
        var query = `select * from zapamcen_zadatak where id_zadatak = ${idZadatka} and id_korisnik = ${idKorisnika};`;
        con.query(query, async function(err, result){
            if(!result[0])
            {
                return res.status(404).send("Zadatak nije zapamćen");  
            }
            else
            {
                var query2 = `delete from zapamcen_zadatak where id_zadatak = ${idZadatka} and id_korisnik = ${idKorisnika};`
                con.query(query2, async function(err, result){
                    if(err)
                    {
                        return res.status(500).send(err.message);
                    }

                });
                return res.status(200).send("Zadatak više nije zapamćen");
            }

        });

    }
    catch(err)
    {
        return res.status(500).send(err.message);
    }

});

app.get('/uradiZadatak/:idZadatka', verify, async function(req, res){
    try
    {
        var idZadatka = con.escape(req.params.idZadatka);
        const token = req.header('auth-token');
        const verified = jwt.verify(token, TAJNA_SVEMIRA);
        var idKorisnika = verified.id;
        var query = `select * from uradjen_zadatak where id_zadatak = ${idZadatka} and id_korisnik = ${idKorisnika};`;
        con.query(query, async function(err, result){
            if(!result[0])
            {
                var query2 = `insert into uradjen_zadatak(id_korisnik, id_zadatak) values(${idKorisnika}, ${idZadatka});`;
                con.query(query2, async function(err, result){
                    if(err)
                    {
                        return res.status(500).send(err.message);
                    }

                });
                return res.status(200).send("Zadatak označen kao urađen");
            }
            else
            {
                return res.status(404).send("Već je zadatak označen kao urađen");
            }

        });

    }
    catch(err)
    {
        return res.status(500).send(err.message);
    }

});


app.get('/odradiZadatak/:idZadatka', verify, async function(req, res){
    try
    {
        var idZadatka = con.escape(req.params.idZadatka);
        const token = req.header('auth-token');
        const verified = jwt.verify(token, TAJNA_SVEMIRA);
        var idKorisnika = verified.id;
        var query = `select * from uradjen_zadatak where id_zadatak = ${idZadatka} and id_korisnik = ${idKorisnika};`;
        con.query(query, async function(err, result){
            if(!result[0])
            {
                return res.status(404).send("Zadatak nije označen kao urađen");  
            }
            else
            {
                var query2 = `delete from uradjen_zadatak where id_zadatak = ${idZadatka} and id_korisnik = ${idKorisnika};`
                con.query(query2, async function(err, result){
                    if(err)
                    {
                        return res.status(500).send(err.message);
                    }

                });
                return res.status(200).send("Zadatak više nije označen kao urađen");
            }

        });

    }
    catch(err)
    {
        return res.status(500).send(err.message);
    }

});


app.get('/ukloniZadatak/:idZadatka', verify, async function(req, res){
    try
    {
        var idZadatka = con.escape(req.params.idZadatka);
        const token = req.header('auth-token');
        const verified = jwt.verify(token, TAJNA_SVEMIRA);
        var idKorisnika = verified.id;
        var query = `select * from uklonjen_zadatak where id_zadatak = ${idZadatka} and id_korisnik = ${idKorisnika};`;
        con.query(query, async function(err, result){
            if(!result[0])
            {
                var query2 = `insert into uklonjen_zadatak(id_korisnik, id_zadatak) values(${idKorisnika}, ${idZadatka});`;
                con.query(query2, async function(err, result){
                    if(err)
                    {
                        return res.status(500).send(err.message);
                    }

                });
                return res.status(200).send("Zadatak uklonjen");
            }
            else
            {
                return res.status(404).send("Zadatak je već uklonjen");
            }

        });

    }
    catch(err)
    {
        return res.status(500).send(err.message);
    }

});


app.get('/otkloniZadatak/:idZadatka', verify, async function(req, res){
    try
    {
        var idZadatka = con.escape(req.params.idZadatka);
        const token = req.header('auth-token');
        const verified = jwt.verify(token, TAJNA_SVEMIRA);
        var idKorisnika = verified.id;
        var query = `select * from uklonjen_zadatak where id_zadatak = ${idZadatka} and id_korisnik = ${idKorisnika};`;
        con.query(query, async function(err, result){
            if(!result[0])
            {
                return res.status(404).send("Zadatak nije uklonjen");  
            }
            else
            {
                var query2 = `delete from uklonjen_zadatak where id_zadatak = ${idZadatka} and id_korisnik = ${idKorisnika};`
                con.query(query2, async function(err, result){
                    if(err)
                    {
                        return res.status(500).send(err.message);
                    }

                });
                return res.status(200).send("Zadatak više nije uklonjen");
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