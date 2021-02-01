
const WebSocket = require("ws");
// const UUID      = require("uuid");
const wss       = new WebSocket.Server({ port: 4444 });
const sleep = require('sleep');
const exec = require('child_process').exec;
const CronJob = require('cron').CronJob;
const commander = require('commander');
const program = new commander.Command();
const clipboardy = require('clipboardy');

program
  .option('-p, --pattern <pattern>', 'cron pattern ', "*/5 * * * * *" )
  .parse(process.argv)
  ;
  // if (! process.argv.slice(2).length) program.help() ;

wss.on("connection", ws => {
  console.log("connected.");
  // ws.send(`connected..`);
  ws.send(JSON.stringify(
    {
      type: "log",
      text: "connected..",
    }
  ));
  // ws.id = UUID();

  ws.on('close', function () {
    console.log("closed.")
  });

  (async function(){

    var obj;
    var text = null;
    var changed;
    var job = new CronJob("*/1 * * * * *", async function() {
      // date = new Date().toLocaleTimeString("en-US", {timeZone: "Asia/Tokyo", year: "numeric", month: '2-digit', day: '2-digit', hour: '2-digit', minute:'2-digit', second:'2-digit', timeZoneName: 'short'});
      changed = false;
        if ( text == null ) changed = true; // when first time
        if ( text ) if ( text !== clipboardy.readSync() ) changed = true; // when clipboard changed
      text = clipboardy.readSync()
      obj = {
        type: "clipboard",
        clipboard: {
          text: text,
          changed: changed,
        },
      }
      if (ws.readyState === WebSocket.OPEN) ws.send(JSON.stringify(obj));
      if (ws.readyState === WebSocket.CLOSED) job.stop();
    });
    job.start();

    // ws.on("message", message => {
    //   console.log("message:", message)
    // });

  })();
});

// var ws = new WebSocket('ws://localhost:4444');
