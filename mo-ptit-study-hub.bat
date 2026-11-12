@echo off
chcp 65001 >nul
title PTIT Study Hub - Local Server
cd /d "%~dp0"
set "PTIT_ROOT=%cd%"

echo ==================================================
echo   PTIT Study Hub - Khoi dong may chu cuc bo (HTTP)
echo   Thu muc: %PTIT_ROOT%
echo ==================================================
echo.

where node >nul 2>nul
if %errorlevel%==0 (
  node -e "const fs=require('fs'),path=require('path'),http=require('http'),{spawn}=require('child_process');const root=process.env.PTIT_ROOT||process.cwd();const mime={'.html':'text/html; charset=utf-8','.js':'application/javascript; charset=utf-8','.mjs':'application/javascript; charset=utf-8','.css':'text/css; charset=utf-8','.json':'application/json; charset=utf-8','.png':'image/png','.jpg':'image/jpeg','.jpeg':'image/jpeg','.svg':'image/svg+xml','.webp':'image/webp','.ico':'image/x-icon','.pdf':'application/pdf','.woff2':'font/woff2'};const srv=http.createServer((req,res)=>{const clean=decodeURIComponent((req.url||'/').split('?')[0]);const rel=clean==='/'?'index.html':clean.replace(/^\/+/,'');let f=path.resolve(root,rel);if(!f.startsWith(path.resolve(root))){res.writeHead(403);return res.end('Forbidden');}if(fs.existsSync(f)&&fs.statSync(f).isDirectory())f=path.join(f,'index.html');if(!fs.existsSync(f)){res.writeHead(404);return res.end('Not found');}const ext=path.extname(f).toLowerCase();res.writeHead(200,{'Content-Type':mime[ext]||'application/octet-stream','Access-Control-Allow-Origin':'*','Referrer-Policy':'strict-origin-when-cross-origin','Cache-Control':'no-cache'});if(req.method==='HEAD')return res.end();fs.createReadStream(f).pipe(res);});let p=8080;function tryListen(){srv.listen(p,'127.0.0.1',()=>{const u='http://127.0.0.1:'+p+'/index.html';console.log('Dang chay tai: '+u);console.log('Phong Video:   http://127.0.0.1:'+p+'/video/index.html?group=vl3');console.log('Nhan Ctrl+C hoac dong cua so nay khi hoc xong.');if(process.env.PTIT_NO_OPEN!=='1'){spawn('cmd',['/c','start','',u],{detached:true,stdio:'ignore'});}});}srv.on('error',e=>{if(e.code==='EADDRINUSE'&&p<8099){p++;tryListen();}else{console.error(e);process.exit(1);}});tryListen();"
  goto :end
)

where python >nul 2>nul
if %errorlevel%==0 (
  echo Dang mo tai: http://127.0.0.1:8080/index.html
  echo Nhan Ctrl+C hoac dong cua so nay khi hoc xong.
  start "" "http://127.0.0.1:8080/index.html"
  python -m http.server 8080 --bind 127.0.0.1
  goto :end
)

echo [Loi] Khong tim thay Node.js hoac Python tren may.
echo Hay cai Node.js / Python hoac mo thu muc bang VS Code Live Server.
pause

:end
