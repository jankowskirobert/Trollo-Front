const electron = require('electron')
// Module to control application life.
const app = electron.app
// Module to create native browser window.
const BrowserWindow = electron.BrowserWindow
const Request = require('request');
const path = require('path')
const url = require('url')


let mainWindow

function sampleRequest(){
  Request.get('https://jsonplaceholder.typicode.com/posts/1', function (error, response, body) {
    if (error) {
      throw error;
    }
    const data = JSON.parse(body);
    console.log(data);
  });
}

function createWindow() {

  mainWindow = new BrowserWindow({ width: 800, height: 600 })

  mainWindow.loadURL(url.format({
    pathname: path.join(__dirname, 'index.html'),
    protocol: 'file:',
    slashes: true
  }))

  mainWindow.on('closed', function () {

    mainWindow = null
  })
  // mainWindow.openDevTools();
}

app.on('ready', createWindow)

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', function () {
  if (mainWindow === null) {
    createWindow()
  }
})

