// index.js

const express = require('express');
const session = require('express-session'); // Pastikan sudah di-install
require('dotenv').config();

const app = express();

const db = require('./src/models/db');
const userRoutes = require('./src/routes/userRoutes');
const janjiTemuRoutes = require('./src/routes/janjiTemuRoutes');
const poliRoutes = require('./src/routes/poliRoutes');
const authRoutes = require('./src/routes/authRoutes');
const scheduler = require('./src/scheduler/scheduler');
const dokterRoutes = require('./src/routes/dokterRoutes');
const resepObatRoutes = require('./src/routes/resepObatRoutes');
const klinikRoutes = require('./src/routes/klinikRoutes');
const artikelRoutes = require('./src/routes/artikelRoutes');
db.getConnection()
  .then(() => console.log('✅ DB connected!'))
  .catch((err) => console.error('❌ DB connection error:', err));


// --- MIDDLEWARE ---
// 1. Middleware untuk membaca body JSON dari request
app.use(express.json()); 

// 2. Middleware SANGAT PENTING untuk sesi login
app.use(
   session({
    secret: process.env.SESSION_SECRET, // Mengambil secret dari .env
    resave: false,
    saveUninitialized: false,
    cookie: {
      secure: process.env.NODE_ENV === 'production',
      // Mengambil maxAge dari .env
      // parseInt() digunakan karena nilai dari .env selalu string
      maxAge: parseInt(process.env.SESSION_MAX_AGE) || 86400000 
    },
  })
);


// --- PENDAFTARAN RUTE ---
// Semua rute didaftarkan di root ('/')
app.use('/', authRoutes);   // Menyediakan: POST /login
app.use('/', userRoutes);   // Menyediakan: POST /register, GET /users, GET /users/:id
app.use('/', poliRoutes);   // Menyediakan rute-rute poli
app.use('/janji-temu', janjiTemuRoutes); // Menyediakan rute-rute janji temu
app.use('/dokter', dokterRoutes);       // Menyediakan rute-rute dokter
app.use('/resep-obat', resepObatRoutes); // Menyediakan rute-rute resep obat
app.use('/klinik', klinikRoutes);       // Menyediakan rute-rute klinik
app.use('/artikel', artikelRoutes);     // Menyediakan rute-rute artikel
app.get('/api/hello', (req, res) => {   // Rute tes
  res.json({ message: 'Halo dari backend!' });
});


// --- SERVER LISTENER (SELALU DI PALING AKHIR) ---
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`); // Memulai server
  scheduler.start(); // Memulai penjadwal
});
