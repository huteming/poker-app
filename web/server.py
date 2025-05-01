from http.server import HTTPServer, SimpleHTTPRequestHandler
import os

class CORSRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET')
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate')
        return super().end_headers()

    def do_GET(self):
        # 设置正确的 MIME 类型
        if self.path.endswith('.js'):
            self.send_response(200)
            self.send_header('Content-type', 'application/javascript')
            self.end_headers()
            with open(os.path.join(os.getcwd(), self.path[1:]), 'rb') as f:
                self.wfile.write(f.read())
        else:
            return super().do_GET()

if __name__ == '__main__':
    server_address = ('', 5500)
    httpd = HTTPServer(server_address, CORSRequestHandler)
    print('Starting server on port 5500...')
    httpd.serve_forever() 