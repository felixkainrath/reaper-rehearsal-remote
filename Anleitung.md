# Probenregie für REAPER und iPhone

## Einmal einrichten

1. Den gesamten Ordner **Probenregie** an seinem dauerhaften Platz lassen. In REAPER 7.79 unter **Actions → Show action list → New action → Load ReaScript** die Datei **Einrichten.lua** auswählen. In der Aktionsliste **Script: Einrichten.lua** markieren und **Run** drücken. Das Skript registriert die Regie und kopiert die Handyseite in den Benutzerordner für Weboberflächen. Nach einem Update erneut ausführen.
2. Unter **Options → Preferences → Control/OSC/web → Add** den Typ **Web browser interface** wählen. Einen freien Port wählen (üblich 8080), Benutzername und Passwort für die Fernbedienung setzen und übernehmen. Die dort angezeigte lokale **Access URL** verwenden. Ein externer Fernzugriff ist für diesen Ablauf überflüssig.
3. iPhone und Rechner ins gleiche private Netz bringen. Der PC darf am LAN-Kabel hängen. In Safari die angezeigte Adresse mit **/probenregie.html** am Ende öffnen. Beispiel: `http://192.168.1.20:8080/probenregie.html`. Die tatsächliche Adresse kommt aus REAPER. Wenn die Seite nicht lädt, zuerst dieselbe Adresse am PC testen, dann Gast-WLAN/Client-Isolation und die Windows-Firewallfreigabe für REAPER im privaten Netz prüfen.
4. In der Vorlage ORTF links/rechts als Stereo-Eingangspaar aufnehmen. Bei getrennten Mono-Spuren links und rechts im Panorama zuordnen. Je Gesangsmikro eine Mono-Spur. Alle gewünschten Spuren scharf schalten und den Eingang am PC abhören bzw. auspegeln. Normalen Aufnahmemodus verwenden, Loop, Punch und Count-in ausschalten. EQ als Spur-FX und Hall z. B. über eine FX-Spur mit Send einrichten. Alle gewünschten Signale müssen zum Master führen. Die Vorlage ohne Audio-Items speichern.
5. Vor jeder Probe ein neues Projekt aus der Vorlage in einen **eigenen Ordner** speichern. **Script: Probenregie.lua** einmal ausführen, das Projekt im aktiven Tab lassen. Auf dem Handy sollte „Gestoppt“ erscheinen. Für die nächste Probe wieder ein leeres Projekt öffnen. Für den späteren Export kannst du die Regie auch mit dem gespeicherten Aufnahmeprojekt starten.

## Während der Probe

- **Probe aufnehmen**. Auf „Aufnahme“ und die laufende Zeit achten. Das bestätigt den Transport. Ob jedes Mikro ein nutzbares Signal liefert, siehst und hörst du am PC.
- Lied auswählen, **Lied beginnt** vor dem Einsatz antippen. Nach dem Ausklang **Lied vollständig beendet**. Der nächste Versuch desselben Stücks bekommt eine eigene Nummer. Absichtlich etwas Raum vor und nach dem Stück lassen.
- Nach einem Abbruch **Teilversuch beendet**. Die Aufnahme zwischen den Tasten läuft weiter. Anweisungen und Pausen bleiben im Gesamtmitschnitt.
- Für Zugaben **＋ Spontaner Titel** wählen und einen Namen eintippen. Derselbe Titel muss bei Wiederholungen gleich geschrieben sein. Diese Auswahl bleibt im lokalen Browserspeicher, die fertigen Regionen im Projekt. Ein anderes iPhone hat seine eigene Liste spontaner Titel.
- **Punktmarker setzen**: Während der Aufnahme den Markernamen vorab eintippen und im gewünschten Moment drücken. Das geht auch zwischen Liedern. Die Markierung erscheint an der Aufnahmeposition im REAPER-Projekt. Der aktuelle Take läuft weiter.
- **Probe beenden** und bestätigen. Ein dabei noch offenes Lied zählt als Teilversuch. War es vollständig, zuerst die Taste „Lied vollständig beendet“ verwenden. Der Stopp am Handy speichert die Aufnahme und das Projekt.

## Schnitt, Mischung und Export als MP3 und WAV

1. Eine Region umfasst die gesamte Probe. Weitere Regionen stehen für einzelne Versuche. Ziehe die linken und rechten **Regionsgrenzen** auf der Zeitleiste an die passende Stelle. Beim Verschieben ganzer Regionen kann REAPER auch die darunterliegenden Items bewegen. Zum bloßen Nachschneiden die Kante ziehen. Das Stück solo anhören oder die Region zum Abhören als Zeitauswahl übernehmen.
2. Die Namen folgen dem Muster **PR | 003 | OK | Earth Song**. Die Nummer zählt Versuche projektweit. Pro exaktem Songtitel gewinnt die höchste gültige Nummer mit Status **OK**. **Teil** bleibt für den Handschnitt verfügbar. Für eine manuelle Auswahl kannst du z. B. einen irrtümlich als vollständig markierten jüngeren Take im Region Manager von **OK** auf **Teil** umbenennen. Schreibweise und Trennzeichen beibehalten. Eine nachträglich von Hand zusammengesetzte Liedfassung am besten in einer Projektkopie bearbeiten, damit die chronologische Gesamtprobe für den Export erhalten bleibt.
3. EQ, Hall und Lautstärken einstellen. Solo/Mute am PC kontrollieren. Beide Formate folgen dem Stereo-Master. Die Grenzen schließen den Hall genau am Regionsende ab. Für mehr Ausklang die rechte Kante nach hinten ziehen.
4. Am Handy **MP3 + WAV am PC exportieren** drücken. Am Rechner die Dateiliste kontrollieren und **Render … files** bestätigen. REAPER schreibt die Gesamtprobe und jeden gewählten Take in beide Formate. Die Dateien liegen beim gespeicherten Projekt im Ordner **Geschnitten**, getrennt nach Format. Jeder Dateiname beginnt mit dem Projektnamen. Bei zehn vollständig gespielten Titeln entstehen elf MP3s und elf WAVs.
5. Bei erneutem Export in einen bereits befüllten Ordner können Dateien aus früheren Exporten liegen bleiben, insbesondere wenn sich die Take-Nummer geändert hat. Für eine eindeutig aktuelle Lieferung im Renderdialog einen neuen Ausgabeordner wählen.

## Systemplanung und Abwägungen

| Baustein | Entscheidung | Kritischer Punkt |
|---|---|---|
| Aufnahme | Ein gespeichertes Projekt pro Probe, kontinuierliche lokale Aufnahme ab Projektanfang | Ein versehentlicher Gesamtstopp beendet die Sitzung. Das Handy verlangt Bestätigung. Ein erneuter Start mit vorhandenen Audio-Items ist gesperrt. |
| Fernbedienung | Safari nutzt REAPERs eingebauten Webserver. Die Regie bestätigt jeden verarbeiteten Befehl. | Funk und Bedienung erzeugen Latenz. Maßgeblich ist der Zeitpunkt der Verarbeitung am Rechner. Nach Verbindungsverlust den offenen Titel prüfen. Für die Bedienung ist ein iPhone vorgesehen. |
| Positionsdaten | Ein offener Titel zur Zeit. Abgeschlossene Takes sind native REAPER-Regionen. | Ein vergessenes Ende kann Musik oder Gespräche einschließen. Beim Stoppen wird ein offener Versuch als Teil markiert. Ein Stromausfall kann seit der letzten Projektsicherung gesetzte Markierungen kosten. |
| Exportentscheidung | Der Bediener beurteilt „vollständig“. Auswahl nach laufender Versuchsnummer, unabhängig von später korrigierten Regionsgrenzen. | Musikalische Qualität und fehlende Takte können nicht automatisch beurteilt werden. Ein Song ohne vollständigen Versuch erscheint ausschließlich im Gesamtmitschnitt. |
| Mischung | Ein Stereo-Master für Gesamtprobe und Lieddateien | Spätere EQ-/Halländerungen erfordern einen neuen Export. Änderungen an Schnitt oder Mix wirken auf beide Ausgabearten. |
| Rendern | Zielauswahl automatisch, endgültige Freigabe am PC | Der Vorgang setzt die Regionsauswahl und die Renderoptionen des aktuellen Projekts. Die Dateiliste im Dialog kontrollieren. Rendern während der laufenden Aufnahme ist gesperrt. |

## Vor der ersten echten Probe

Eine Minute mit allen Mikrofonen testen. Einen Titel komplett spielen, denselben abbrechen und die Probe beenden. Zwei MP3s und zwei WAVs erwarten. Auf dem iPhone kurz das WLAN ausschalten und wieder verbinden. Am PC die Aufnahme auf beiden ORTF-Kanälen und jeder Gesangsspur prüfen. So werden Raum, Interface, Windows-Firewall und das tatsächliche iPhone mitgetestet.
