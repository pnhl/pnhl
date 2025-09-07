# Cloudflare Pages Configuration

## Build Settings
- **Framework preset**: None
- **Build command**: `echo "Static site - no build required"`
- **Build output directory**: `/`
- **Root directory**: `/`

## Environment Variables
```
NODE_VERSION=18
```

## Pages Rules
- Cache static assets (HTML, CSS, JS, images)
- Skip APK files from build process
- Enable direct file serving

## Deployment
1. Connect GitHub repository: `pnhl/pnhl`
2. Set production branch: `main` 
3. Configure build settings as above
4. Deploy

## APK Download Links
Since APK files are too large for Cloudflare Pages, use direct GitHub links:

```html
<a href="https://github.com/pnhl/pnhl/raw/main/CameraGold-v1.1-Official.apk">
  Download Camera Gold APK v1.1 (41MB)
</a>
```

## Troubleshooting
- **Build timeout**: Use static site without build process
- **File size limits**: Exclude APK files from Cloudflare deployment
- **Missing files**: Ensure all required files are in repository root
