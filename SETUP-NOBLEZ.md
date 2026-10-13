# Etsy-MCP für Noblez (Lennox + Bruder)

Fork von [aserper/etsy-mcp](https://github.com/aserper/etsy-mcp) (MIT). Einzige Änderung:
fester OAuth-Port 3003, weil Etsy eine exakt registrierte Redirect-URL verlangt.

Etsy-App: **noblez-shop-tools** (Seller App, Status Approved, 10 QPS / 10K QPD).
Keystring und Shared Secret stehen unter https://www.etsy.com/developers/ (nur Lennox' Etsy-Konto).
**Secrets nie ins Repo committen** (`.env` ist in `.gitignore`).

## Einmalig in der Etsy-App (nur Lennox)

1. https://www.etsy.com/developers/ → App `noblez-shop-tools` → App Action Menu → Edit.
2. Callback-URL eintragen: `http://localhost:3003/callback`
3. Keystring + Shared Secret kopieren (für Schritt 2 unten).

## Installation auf jedem Mac

```bash
git clone https://github.com/speazymonkey/etsy-mcp.git ~/etsy-mcp
cd ~/etsy-mcp
./install-noblez.sh
```

Das Skript macht: `npm install`, `npm run build`, fragt Keystring + Shared Secret ab,
schreibt `~/etsy-mcp/.env` und registriert den Server in Claude Code
(`claude mcp add etsy`). Voraussetzung: Node 20+ und Claude Code installiert.

Danach in Claude Code: `/mcp` → `etsy` muss „Connected" zeigen. Beim ersten Aufruf das
Werkzeug `authenticate` ausführen (öffnet den Browser, mit Lennox' Etsy-Konto bestätigen).
Tokens liegen danach in `~/.etsy-mcp/tokens.json` (nur eigener Benutzer lesbar).

## Was der Server kann (37 Werkzeuge)

- Bestellungen: `get_shop_receipts`, `get_receipt`, `update_receipt`, **`create_shipment`** (Sendungsnummer eintragen)
- Transaktionen, Angebote (`get_listings_by_shop`, `update_listing`, Inventar, Bilder)
- Versandprofile, Bewertungen, Zahlungen/Ledger, Rückgaberichtlinien

## Typischer Ablauf Etsy-Bestellung bei Noblez

1. `get_shop_receipts` (offene Bestellungen) → Adresse/Artikel lesen
2. Label erstellen (Shopify Shipping / easyDHL / DHL-Portal, siehe Skill `versandlabel`)
3. `create_shipment` mit Sendungsnummer + Carrier `dhl` → Etsy markiert als verschickt

## Nachrichten der Kunden

Die Etsy-API (v3) hat keine Funktion, um Kundennachrichten zu lesen oder zu senden. Zwei Wege:
Claude in Chrome liest etsy.com/messages im eingeloggten Browser, oder Etsys Benachrichtigungs-Mails
werden über Gmail gelesen. Anleitung für den Bruder: [SETUP-BRUDER.md](SETUP-BRUDER.md).
