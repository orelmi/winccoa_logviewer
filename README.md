# Log Viewer Http Handler

A lightweight http handler for real-time log visualization with filtering, color coding, and user controls.

## 🚀 Features

- ✅ Real-time log display from an API
- 🎨 Color-coded log levels (`INFO`, `WARNING`, `ERROR`, `SEVERE`)
- 🔍 Keyword-based filtering
- ⏸️ Scroll pause mode
- 🧊 Freeze mode to stop updates
- 📏 Maximum line limit to prevent overload (default: 1000)

## 🛠️ Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/orelmi/winccoa_logviewer.git
   ```
2. Copy files to project folder

3. Add Control Manager with options ```webclient_http.ctl```

## 📄 Usage

To use the log viewer:

1. Open URL https://localhost/logs/ in any modern browser (Chrome, Firefox, Edge).
2. The page displays the list of log files on the WinCC OA Server
3. Select a file
4. The page will automatically start fetching logs from the configured API.
	- Use the controls at the top of the page:
	- Pause scroll: Prevents auto-scrolling to the bottom.
	- Freeze updates: Temporarily stops fetching new logs.
	- Filter: Enter a keyword to show only matching log lines.
	- The background color changes based on the mode:
		- 🧊 Light blue when frozen
		- 🌕 Light yellow when scroll is paused
		
		
## 📸 Screenshots

Here are two screenshots showing the app in action:

![Logs page](https://github.com/orelmi/winccoa_logviewer/tree/main/assets/page_logs.png)

![LogViewer page](https://github.com/orelmi/winccoa_logviewer/tree/main/assets/page_logviewer.png)

