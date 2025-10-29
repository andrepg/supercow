/**
* copyright @ André Paul Grandsire
*
* This script is available as-is. You can copy, download, modify and distribute if you want. 
* We are not responsible for any damage or problem that the script usage could incur. 
*
* This is a simple script to call a Discord Webhook to notify about some event. 
* In my case, I want to notify when a Digital Ocean build starts and finish. 
* This goal was achieved by using `prebuild` and `postbuild` NPM scripts. 
* 
* The payload was designed with the help of https://discohook.app/
*
*/
import fs from "fs";

const application = JSON.parse(fs.readFileSync("./package.json", "utf8"));

const WEBHOOK_URL = process.env.DISCORD_WEBHOOK_URL;

if (!WEBHOOK_URL) {
    console.log("DISCORD_WEBHOOK_URL environment variable is not set.");
    process.exit(0);
}

const body = {
    "embeds": [
        {
            "title": "🤖 Application build started",            
            "description": "The build has started on CI",
            "fields": [
                {
                    "name": "📦️ Version",
                    "value": application.version,
                    "inline": true
                },
                {
                    "name": "⏰️ Build Time",
                    "value": new Date(Date.now()).toLocaleString('pt-BR'),
                    "inline": true
                },
                {
                    "name": "⚙️ Engine",
                    "value": 'NodeJS ' + process.version + ' | NextJS ' + application.dependencies.next,
                    "inline": false
                },
                {
                    "name": "🎨 Interface",
                    "value": 'React ' + application.dependencies.react,
                    "inline": false
                }
            ]
        }
    ],
    "components": []
};

fetch(WEBHOOK_URL, {
    headers: {
        'Content-Type': 'application/json'
    },
    method: 'POST',
    body: JSON.stringify(body)
})
.then(res => console.log('Discord notified with status:', res.status))
.catch(err => console.error('Error notifying Discord: \n', err));
