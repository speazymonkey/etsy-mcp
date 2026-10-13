# Etsy-Anbindung für Claude Code einrichten (Bruder)

Ziel: Claude Code auf deinem Mac kann Etsy-Bestellungen lesen und Sendungsnummern eintragen.
Der Etsy-Shop und die App „noblez-shop-tools" laufen auf demselben Etsy-Konto. Du loggst dich dort
einfach selbst ein und kopierst Keystring und Shared Secret selbst. Nichts davon kommt in GitHub.

## Teil 1: Voraussetzungen (einmalig prüfen)

Im Terminal:

```
node -v        # muss v20 oder höher zeigen
git --version
claude --version
```

Fehlt etwas: Node von https://nodejs.org installieren, Claude Code mit `npm install -g @anthropic-ai/claude-code`.

## Teil 2: Zugangsdaten holen

1. In Chrome bei Etsy einloggen (das Noblez-Konto).
2. https://www.etsy.com/developers/ öffnen.
3. Bei der App **noblez-shop-tools** den **Keystring** kopieren (sichtbar).
4. Das **Shared Secret** über das Augen-Symbol anzeigen und kopieren.

## Teil 3: Installieren (im Terminal, nicht im Claude-Chat)

```
git clone https://github.com/speazymonkey/etsy-mcp.git ~/etsy-mcp
cd ~/etsy-mcp
./install-noblez.sh
```

Das Skript fragt nach Keystring und Shared Secret. Beides einfügen und Enter drücken. Das Secret
wird beim Einfügen nicht angezeigt, das ist normal. Am Ende steht „Fertig".

## Teil 4: Claude Code neu starten und anmelden

1. Claude Code beenden (`/exit`) und neu starten (`claude`).
2. In Claude Code diesen Satz eingeben:

   > Rufe das Werkzeug `authenticate` vom Etsy-Server auf, damit ich mich bei Etsy anmelden kann.

3. Es öffnet sich Etsy im Browser. Mit dem Noblez-Konto auf „Zugriff erlauben" klicken.
   Danach steht dort „Authorization successful". Das Fenster kann zu.

## Teil 5: Testen

> Zeige mir mit dem Etsy-Werkzeug meine offenen Bestellungen (bezahlt, nicht versendet, Status nicht „Canceled").

Dabei muss Shop-ID **55723171** erscheinen.

## Sendungsnummer eintragen

> Trage bei Etsy-Bestellung <Bestellnummer> die Sendungsnummer <Nummer> ein, Versanddienst DHL.

## Hinweise

- Das Programm läuft nur lokal. Zugangsdaten liegen in `~/etsy-mcp/.env` und `~/.etsy-mcp/tokens.json`
  (nur für dich lesbar). Nie in GitHub hochladen, nie per Mail verschicken.
- Nachrichten von Kunden kann die Etsy-API nicht lesen. Dafür geht nur der Browser (Claude in Chrome)
  oder die Benachrichtigungs-Mails von Etsy.
- Antwortet das Werkzeug mit „Authentication failed", einfach nochmal `authenticate` aufrufen.
- Backup: Wenn etwas hakt, schreib Lennox die genaue Fehlermeldung.
