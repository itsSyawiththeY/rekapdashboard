// Dijalankan Netlify saat build: bikin public/config.js dari environment variables
const fs = require('fs');
try { require('fs').readFileSync('.env', 'utf8').split('\n').forEach(l => {
  const m = l.match(/^\s*([A-Z_]+)\s*=\s*(.*)\s*$/); if (m && !process.env[m[1]]) process.env[m[1]] = m[2];
}); } catch (_) {}

const { SUPABASE_URL, SUPABASE_ANON_KEY } = process.env;
if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
  console.error('SUPABASE_URL dan SUPABASE_ANON_KEY belum di-set.');
  process.exit(1);
}
fs.writeFileSync('public/config.js',
  `window.APP_CONFIG = ${JSON.stringify({ SUPABASE_URL, SUPABASE_ANON_KEY })};\n`);
console.log('public/config.js dibuat.');
