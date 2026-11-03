# REAPER Rehearsal Remote

Record a whole band or orchestra rehearsal in REAPER and mark songs from your phone. After rehearsal, export the full session and the latest complete take of each song as both MP3 and WAV.

**This project was created with AI.** OpenAI Codex generated the REAPER scripts, mobile web interface, tests, and documentation based on the project author's rehearsal workflow.

## Quick start

Tested with REAPER 7.79 on Windows. The phone interface is in German. The instructions below use the labels you will see on screen.

1. Download and extract the project. Keep the folder in its final location so REAPER can find the scripts after setup.
2. In REAPER, open **Actions → Show action list → New action → Load ReaScript**. Load and run `Einrichten.lua` once.
3. Under **Preferences → Control/OSC/web → Add**, choose **Web browser interface** and set a username and password. Connect your phone to the same private network as the computer. Open the local address shown in REAPER and append `/probenregie.html`.
4. Save a new project with your microphone tracks armed and the timeline empty. Run `Probenregie.lua`. Your phone should show **Gestoppt** (stopped). If you switch project tabs, run the script again in the project you want to control.
5. Tap **Probe aufnehmen** (start recording). Select a song or enter a title, then tap **Lied beginnt** at the start. At the end, tap **Lied vollständig beendet** for a complete take or **Teilversuch beendet** for a partial take. Recording continues between songs.

## Mark a moment

Type a name such as “Bar 42 – check brass entry”, then tap **Punktmarker setzen** at the moment you want to mark. REAPER adds a named marker at the current recording position and confirms it on your phone. You can do this during or between songs. The name stays in the field so you can mark the same issue again. You can edit these markers in REAPER later.

## Customize the setlist

Copy `probenregie-setliste.js` to `setliste.lokal.js` in the project folder and enter your song titles:

```js
window.probenSetliste = ["Opening Number", "Encore"];
```

Run `Einrichten.lua` again and reload the page on your phone. Git ignores the local setlist. You can also enter titles during rehearsal without preparing a list.

## Export the rehearsal

Tap **Probe beenden** to stop recording, then **MP3 + WAV am PC exportieren** to open the render dialog on the computer. Review the files and confirm. If you played a song twice and abandoned the second attempt, the individual song export uses the first complete take. The full rehearsal includes both attempts.

REAPER writes the files to `Geschnitten/mp3/` and `Geschnitten/wav/` beside the saved project. Each filename starts with the project name. Both formats use the stereo master mix, including EQ and reverb.

## Documentation and tests

- For installation, editing, and troubleshooting, see the [user guide (German)](Anleitung.md). For the checks performed and their results, see the [test report (German)](Testbericht.md).
- To test the browser controls, run `node tests/handy.cjs` from the project folder. Node.js is only needed for the JavaScript tests.
- The Lua tests create project content. Run them in a separate temporary REAPER instance with an empty test project. For the controller test, copy `Probenregie.lua`, `regionen.lua`, and `tests/controller.lua` into a temporary folder, save an empty project there, and run `controller.lua`. The first line of `controller-result.txt` should read `true`.

## License

You may use, modify, and redistribute this software, including commercially. Keep the copyright and permission notices with copies or substantial portions of the software. [MIT License](LICENSE)
