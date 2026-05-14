const http = require('http');
const fs = require('fs');
const path = require('path');

const port = 8000;
const root = process.cwd();

const mimeTypes = {
    '.html': 'text/html',
    '.js': 'text/javascript',
    '.css': 'text/css',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.gif': 'image/gif',
    '.svg': 'image/svg+xml',
    '.mp3': 'audio/mpeg'
};

const server = http.createServer((req, res) => {
    // Handle file upload
    if (req.method === 'POST' && req.url === '/upload') {
        let body = [];
        const filename = req.headers['x-filename'];
        
        if (!filename) {
            res.writeHead(400);
            return res.end('Missing filename');
        }

        req.on('data', (chunk) => { body.push(chunk); });
        req.on('end', () => {
            const buffer = Buffer.concat(body);
            const dir = path.join(root, 'assets', 'audio');
            
            if (!fs.existsSync(dir)) { fs.mkdirSync(dir, { recursive: true }); }
            
            fs.writeFile(path.join(dir, filename), buffer, (err) => {
                if (err) {
                    res.writeHead(500);
                    res.end('Error saving file');
                } else {
                    res.writeHead(200);
                    res.end('File uploaded successfully');
                }
            });
        });
        return;
    }

    let filePath = path.join(root, req.url === '/' ? 'index.html' : req.url);
    const ext = path.extname(filePath).toLowerCase();
    const contentType = mimeTypes[ext] || 'application/octet-stream';

    fs.readFile(filePath, (error, content) => {
        if (error) {
            if (error.code === 'ENOENT') {
                res.writeHead(404);
                res.end('404 Not Found');
            } else {
                res.writeHead(500);
                res.end('500 Internal Error');
            }
        } else {
            res.writeHead(200, { 'Content-Type': contentType });
            res.end(content, 'utf-8');
        }
    });
});

server.listen(port, '127.0.0.1', () => {
    console.log(`Server running at http://127.0.0.1:${port}/`);
});
