# Probenregie für REAPER

Eine Handy-Fernbedienung für Band- und Orchesterproben. REAPER zeichnet die Probe am Rechner durchgehend auf. Im Browser markierst du Liedanfänge, vollständige Takes, Teilversuche und einzelne Stellen, die du später wiederfinden möchtest.

## Schnellstart

1. Projekt herunterladen und entpacken. Getestet mit REAPER 7.79 unter Windows. Der Ordner mit den Lua-Dateien muss nach der Einrichtung am selben Platz bleiben.
2. In REAPER unter **Actions → Show action list → New action → Load ReaScript** die Datei **Einrichten.lua** laden und einmal ausführen.
3. Unter **Preferences → Control/OSC/web → Add** ein **Web browser interface** ins private Proben-Netz einrichten. Benutzername und Passwort setzen. Die dort angezeigte lokale Adresse auf dem Handy mit **/probenregie.html** am Ende öffnen.
4. Ein neues, leeres Probenprojekt mit vorbereiteten, scharf geschalteten Mikrofonspuren speichern. Die Aktion **Probenregie.lua** starten. Das Handy meldet „Gestoppt“. Nach einem Projektwechsel die Aktion im gewünschten Projekt neu starten.
5. **Probe aufnehmen** antippen. Einen Titel wählen oder spontan eingeben. Mit **Lied beginnt** und **Lied vollständig beendet** oder **Teilversuch beendet** die Grenzen festlegen.

## Punktmarker

Während der Aufnahme einen Namen eintippen, etwa „Takt 42 – Einsatz prüfen“. Im gewünschten Moment **Punktmarker setzen** antippen. REAPER legt an der aktuellen Aufnahmeposition einen benannten Projektmarker an und bestätigt ihn auf dem Handy. Das funktioniert mitten im Lied und zwischen zwei Stücken. Der eingegebene Name bleibt für wiederholte Markierungen stehen. Die Marker sind in REAPER bearbeitbar und erzeugen keine zusätzliche Exportdatei.

## Setliste anpassen

Kopiere **probenregie-setliste.js** im Projektordner nach **setliste.lokal.js**. Beispielinhalt:

```js
window.probenSetliste = ["Erstes Stück", "Zugabe"];
```

**Einrichten.lua** erneut ausführen und die Handyseite neu laden. Persönliche Setlisten sind von Git ausgeschlossen. Ohne eigene Liste kannst du direkt mit spontanen Titeln arbeiten.

## Export

Nach **Probe beenden** öffnet **MP3 + WAV am PC exportieren** den REAPER-Renderdialog. Nach deiner Bestätigung landen die gesamte Probe und der letzte vollständige Take je Lied unter **Geschnitten/mp3** und **Geschnitten/wav** neben der Projektdatei. Jeder Dateiname beginnt mit dem Projektnamen. Beide Formate folgen dem Stereo-Master, einschließlich EQ und Hall.

## Dokumentation und Tests

- [Einrichtung, Schnitt und Fehlerbehebung](Anleitung.md)
- [Bisherige Tests](Testbericht.md)
- Browserlogik lokal testen: `node tests/handy.cjs`. Node.js wird nur für den Test benötigt.
- Die Lua-Testskripte sind Entwickler-Fixtures für **separate temporäre REAPER-Instanzen und leere Testprojekte**. Sie erzeugen Projektinhalte. Für den Controller-Test die Dateien Probenregie.lua, regionen.lua und tests/controller.lua in einen temporären Ordner kopieren, dort ein leeres Testprojekt speichern und controller.lua in der Testinstanz ausführen. In controller-result.txt muss in der ersten Zeile true stehen.

## Lizenz

[MIT](LICENSE). Verwendung, Änderung und Weitergabe sind auch kommerziell erlaubt. Copyright- und Lizenzhinweis müssen in Kopien oder wesentlichen Teilen enthalten bleiben.
