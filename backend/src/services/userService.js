// src/services/userService.js

const userModel = require('../models/userModel');
const otpModel = require('../models/otpModel');
const emailService = require('./emailService');
const bcrypt = require('bcryptjs');

exports.requestRegistration = async (userData) => {
  // === PERBAIKAN DI SINI: Gunakan snake_case ===
  const { nama_depan, nama_belakang, jenis_kelamin, ttl, username, email, password } = userData;

  if (await userModel.findByUsername(username)) throw new Error('Username sudah digunakan');
  if (await userModel.findByEmail(email)) throw new Error('Email sudah terdaftar');

  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  const otpHash = await bcrypt.hash(otp, 10);
  const expiresAt = new Date(Date.now() + 10 * 60 * 1000);

  // Simpan data ke tabel OTP
  // Karena variabelnya sudah snake_case, kita bisa langsung menuliskannya
  await otpModel.create(email, otpHash, { nama_depan, nama_belakang, jenis_kelamin, ttl, username, password }, expiresAt);

  await emailService.sendOtpEmail(email, otp);
  return { message: `Kode OTP telah dikirim ke ${email}` };
};

exports.verifyRegistration = async (email, otp) => {
  const otpData = await otpModel.findByEmail(email);
  if (!otpData) throw new Error('OTP tidak valid atau sudah kedaluwarsa.');

  if (new Date() > new Date(otpData.expires_at)) {
    await otpModel.deleteByEmail(email);
    throw new Error('OTP sudah kedaluwarsa.');
  }

  const isMatch = await bcrypt.compare(otp, otpData.otp_hash);
  if (!isMatch) throw new Error('Kode OTP salah.');

  const userData = JSON.parse(otpData.user_data);
  const pepperedPassword = userData.password + process.env.PASSWORD_PEPPER;
  const hashedPassword = await bcrypt.hash(pepperedPassword, 10);

  // === PERBAIKAN DI SINI: Gunakan snake_case ===
  const finalUserData = {
    nama_depan: userData.nama_depan,
    nama_belakang: userData.nama_belakang,
    jenis_kelamin: userData.jenis_kelamin, // Ambil dari data tersimpan
    ttl: userData.ttl,
    username: userData.username,
    email: email,
    password: hashedPassword,
    role: 'user',
  };

  const newUser = await userModel.createUser(finalUserData);
  await otpModel.deleteByEmail(email);
  delete newUser.password;
  return newUser;
};

// ... (sisa fungsi lain seperti getUserByUsername) ...
exports.getUserByUsername = async (username) => {
  console.log(`[UserService] Mencari pengguna dengan username: ${username}`);
  const user = await userModel.findByUsername(username);
  return user;
};