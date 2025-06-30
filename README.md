# Memo Sticky Universal Link Setup

This directory contains the files needed to set up Universal Link support for the Memo Sticky app on ray-zhang.xyz domain.

## Files Structure

```
github-pages/
├── apple-app-site-association    # Universal Link configuration (no extension)
├── index.html                     # Main landing page for app download
├── u/
│   └── entry/
│       └── index.html            # Universal Link entry point
└── README.md                     # This file
```

## Setup Instructions

### 1. Domain Setup

The Universal Link is configured for the custom domain `ray-zhang.xyz` with the path `/post_it_note_share/`.

### 2. File Structure

Files are deployed at:
- Main page: `https://ray-zhang.xyz/post_it_note_share/`
- Universal Link entry: `https://ray-zhang.xyz/post_it_note_share/u/entry`
- Association file: `https://ray-zhang.xyz/post_it_note_share/.well-known/apple-app-site-association`

### 3. Verify Setup

1. Visit `https://ray-zhang.xyz/post_it_note_share/` to see the main page
2. Visit `https://ray-zhang.xyz/post_it_note_share/.well-known/apple-app-site-association` to verify the association file
3. Test the Universal Link: `https://ray-zhang.xyz/post_it_note_share/u/entry?text=Hello%20World`

## How It Works

### Sharing Flow
1. User swipes right on a note in the app
2. Share sheet opens with message: "I wrote a new note, click to view: https://ray-zhang.xyz/post_it_note_share/u/entry?text=..."
3. When shared link is clicked:
   - If app is installed: Opens app directly with the shared text
   - If app is not installed: Shows download page

### Universal Link Configuration
- Domain: `ray-zhang.xyz`
- Path: `/post_it_note_share/u/entry*`
- App ID: `3HWBZVW7QW.com.dongjiezhang.Post-It-Notes`
- App Store URL: `https://apps.apple.com/app/memo-sticky/id1508032147`

## Important Notes

- The domain is configured for `ray-zhang.xyz/post_it_note_share/`
- App Store URL is set to `https://apps.apple.com/app/memo-sticky/id1508032147`
- The `apple-app-site-association` file must be accessible at `https://ray-zhang.xyz/post_it_note_share/.well-known/apple-app-site-association`
- Associated Domains in the app are configured for `applinks:ray-zhang.xyz`

## Testing

1. Build and install the app on a device
2. Share a note and send the link to yourself
3. Click the link in Messages or another app
4. The app should open with the shared text pre-filled

## Troubleshooting

- If Universal Links don't work, check that the `apple-app-site-association` file is accessible
- Verify the App ID in the association file matches your app's bundle identifier and team ID
- Make sure Associated Domains are properly configured in Xcode
- Universal Links may take some time to be recognized by iOS after installation