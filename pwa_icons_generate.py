import subprocess
import json

def generate_files(image_file, app_info):
    # Generate site.webmanifest
    with open('./priv/static/site.webmanifest', 'w') as f:
        json.dump(app_info, f, indent=4)

    sizes = [
        ("./priv/static/android-chrome-192x192.png", "192x192"),
        ("./priv/static/android-chrome-512x512.png", "512x512"),
        ("./priv/static/apple-touch-icon.png", "180x180"),
        ("./priv/static/favicon.ico", "48x48"),
        ("./priv/static/favicon-16x16.png", "16x16"),
        ("./priv/static/favicon-32x32.png", "32x32"),
        ("./priv/static/mstile-150x150.png", "150x150"),
        ("./priv/static/mstile-70x70.png", "70x70"),
        ("./priv/static/mstile-310x310.png", "310x310")
    ]

    for filename, size in sizes:
            subprocess.run(['convert', image_file, '-resize', size+'^', '-gravity', 'center', '-extent', size, filename])

    # Generate browserconfig.xml
    with open('./priv/static/browserconfig.xml', 'w') as f:
        f.write('<?xml version="1.0" encoding="utf-8"?>')
        f.write('<browserconfig>')
        f.write('<msapplication>')
        f.write('<tile>')
        f.write('<square70x70logo src="mstile-70x70.png"/>')
        f.write('<square150x150logo src="mstile-150x150.png"/>')
        f.write('<square310x310logo src="mstile-310x310.png"/>')
        f.write('<TileColor>#1d232a</TileColor>')
        f.write('</tile>')
        f.write('</msapplication>')
        f.write('</browserconfig>')

if __name__ == "__main__":
    app_info = {
        "name": "ToDo",
        "short_name": "ToDo",
        "description": "A local-first to-do app.",
        "id": "/",
        "scope": "/",
        "start_url": "/",
        "theme_color": "#1d232a",
        "background_color": "#1d232a",
        "display": "standalone",
        "icons": [
            {
                "src": "/android-chrome-192x192.png",
                "sizes": "192x192",
                "type": "image/png"
            },
            {
                "src": "/android-chrome-512x512.png",
                "sizes": "512x512",
                "type": "image/png"
            },
            {
                "src": "/apple-touch-icon.png",
                "sizes": "180x180",
                "type": "image/png"
            }
        ]
    }

    input_image = './priv/static/og.png'  # Replace with your input image file path
    generate_files(input_image, app_info)
