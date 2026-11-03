# Testbericht und Revision · 3. November 2026

Getestet mit der installierten REAPER-Version 7.79 unter Windows in getrennten Instanzen und temporären Projekten. Für keinen Test wurde ein physischer Mikrofoneingang benötigt.

| Prüfung | Ergebnis |
|---|---|
| Echter Transport mit Dummy-Audiotreiber | Aufnahme gestartet, Lied begonnen und vollständig beendet, zweiten Versuch begonnen, Gesamtprobe am Regie-Endpunkt gestoppt. Ein Audio-Item und drei native Regionen im gespeicherten Projekt. |
| Render-Test | Synthetische Aufnahme mit fünf unterscheidbaren Tönen. Zwei vollständige Versuche von „Feuer“, ein vollständiger von „Luft“, ein späterer Abbruch von „Feuer“, ein reines Fragment und eine fremde Region. REAPER erzeugte nur drei MP3s. |
| Audioanalyse der Revision | „Luft“ 1,000 s, 300 Hz. „Feuer“ 1,000 s, 400 Hz. Gesamtprobe 5,000 s, gemessen 200/302/400/500/598 Hz, Soll 200/300/400/500/600 Hz. Alle Dateien Stereo-MP3 mit 256.000 bit/s. Die Frequenzmessung zählt positive Nulldurchgänge über jeweils eine halbe Sekunde. |
| Steuerlogik | In REAPER mit simuliertem Transport geprüft: Überalterter Startbefehl ignoriert, gültiger Start angenommen, Umlauttitel korrekt, wiederholtes altes Startpaket ignoriert, offener Versuch bei Stopp als Teil markiert. |
| Handylogik | JavaScript der ausgelieferten HTML-Datei mit simuliertem Web-Endpunkt ausgeführt. Zehn Playlist-Einträge, spontane Titel, Aufnahmestatus, Freigabe/Sperre der Tasten und Bestätigungen geprüft. |
| Physische Umgebung | Safari auf dem konkreten iPhone, WLAN-Empfang, Firewall, tatsächliche Mikrofone, EQ und Hall vor Ort sind offen. Dafür steht der Kurztest am Ende der Anleitung. |

## Änderungen durch die Revision

- Der erste echte Export lieferte Stereo-MP3 mit 128 kbit/s. Die Regie setzt jetzt 256 kbit/s explizit. Format und Inhalt der neu gerenderten Dateien wurden erneut gemessen.
- Handy-Befehle tragen Versionsstand und Zeitstempel des Rechners. REAPER akzeptiert einen Befehl nur für den aktuellen Zustand und innerhalb von fünf Sekunden. Der Browser wiederholt unbestätigte Aktionen nicht automatisch.
- Der Stopp verwendet REAPERs Aktion „Stop (save all recorded media)“, damit der Mitschnitt übernommen wird.
- Beim ersten echten Aufnahmetest endete die Gesamtregion bei 4,832 s und das Audio bei 4,864 s. Nach Korrektur und neuer Aufnahme lagen Gesamtregionsende und Itemende beide bei **4,864 s**.

## Doppelexport

REAPER 7.79 erzeugte für das Projekt Bandprobe unter Geschnitten drei MP3s im Ordner mp3 und drei PCM-WAVs im Ordner wav. Alle sechs Dateinamen begannen mit Bandprobe. FFprobe bestätigte Stereo, 256 kbit/s für MP3, 24 Bit für WAV sowie identische Dauern je Paar (1, 1 und 5 Sekunden).

## Benannte Punktmarker

Browserlogik mit simuliertem Web-Endpunkt und Controller in REAPER mit simuliertem Transport geprüft. Der Marker Bläser erschien als einzelner nativer Punktmarker bei 1,5 Sekunden. Eine doppelte Zustellung und leere Namen erzeugten keine zusätzlichen Marker. Der laufende Liedbereich wurde weiterhin korrekt abgeschlossen.
