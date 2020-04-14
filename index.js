// Create express application.
const express = require('express');
const app = express();

// Create middleware, body-parser
const bodyParser = require('body-parser');
// Configure express to use body-parser as middleware.
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false}));

// Create connection to database
const mysql = require('mysql');
const config = require('./config/account.json');
const db = mysql.createConnection(config);

// Connect to database
db.connect((err) => {
    if(err) {
        console.log('Not connected to database');
    }
    else {
        console.log('Connected to database.');
    }
});

app.set('view engine', 'ejs');
app.use(express.static('public'));

// Create account page
app.get('/', (req, res) => {
    res.render('create', {
        title: "Account | Create"
    });
});

app.post('/', (req, res) => {
    let value = [req.body.id, req.body.name, req.body.deposit];
    let sql = `CALL create_account(?, ?, ?);`;
    db.query(sql, value, (err, result) => {
        if(err) {
            console.log("Error occured. " + err);
            return;
        }
        res.redirect('/')
    });
});

app.get('/account', (req, res) => {
    let sql = `CALL show_account();`;
    db.query(sql, (err, result) => {
        if(err) throw err;
        res.render('account', {
            title: "Account | List",
            data: result[0]
        });
    });
})

app.get('/account/deposit/:id', (req, res) => {
    let id = req.params.id;
    res.render('deposit_withdrawal', {
        title: "Deposit",
        id: id
    });
})

app.post('/account/deposit/:id', (req, res) => {
    let value = [req.params.id, req.body.amount];
    let sql = `CALL deposit(?, ?);`;
    db.query(sql, value, (err, result) => {
        if(err) {
            console.log("Error occured. " + err);
            return;
        }
        res.redirect('/account')
    });
})

app.get('/account/withdrawal/:id', (req, res) => {
    let id = req.params.id;
    res.render('deposit_withdrawal', {
        title: "Withdrawal",
        id: id
    });
})

app.post('/account/withdrawal/:id', (req, res) => {
    let value = [req.params.id, req.body.amount];
    let sql = `CALL withdrawal(?, ?);`;
    db.query(sql, value, (err, result) => {
        if(err) {
            console.log("Error occured. " + err);
            return;
        }
        res.redirect('/account')
    });
})

app.get('/account/history/:id', (req, res) => {
    let id = req.params.id;
    let sql = `CALL history(?);`;
    db.query(sql, id, (err, result) => {
        if(err) throw err;
        res.render('history', {
            title: "History",
            data: result[0]
        })
    })
})

app.get('/account/close/:id', (req, res) => {
    let id = req.params.id;
    let sql = `CALL close(?);`;
    db.query(sql, id, (err, result) => {
        if(err) throw err;
        res.redirect('/account')
    })
})

app.get('/account/transfer/:id', (req, res) => {
    let id = req.params.id;
    let sql = `CALL select_id(); CALL id_balance(?);`;
    db.query(sql, id, (err, result) => {
        if(err) throw err;
        res.render('transfer', {
            title: "Transfer",
            id: id,
            data: result[0],
            data1: result[2][0]
        })
    })
})

app.post('/account/transfer/:id', (req, res) => {
    let id = req.params.id;
    let value = [req.params.id, req.body.receiver, req.body.amount];
    let sql = `CALL transfer(?, ?, ?);`;
    db.query(sql, value, (err, result) => {
        if(err) {
            console.log("Error occured. " + err);
            return;
        }
        res.redirect('/account')

    })
})

app.listen(8000, () => {
    console.log("Server started on port 8000");
});