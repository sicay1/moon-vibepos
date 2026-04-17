# Google Sheets Sync — Setup Guide

Sync your MoonPos orders to Google Sheets using a **Google Apps Script Web App**.
No Google Cloud Console, no OAuth, and no login required.

---

## Step 1 — Create the Google Sheet

1. Go to [sheets.google.com](https://sheets.google.com) and create a new spreadsheet.
2. Rename **Sheet1** → `Orders Summary`
3. Click the **+** button to add a second sheet → rename it to `Order Details`

> Sheet names must be **exactly** `Orders Summary` and `Order Details` (case-sensitive).

---

## Step 2 — Open Apps Script

1. In your spreadsheet, click **Extensions → Apps Script**
2. Delete any existing code in the editor
3. Paste the following script and click **Save** (Ctrl+S):

```javascript
function doPost(e) {
  try {
    var ss = SpreadsheetApp.getActiveSpreadsheet();
    var payload = JSON.parse(e.postData.contents);

    // ── Orders Summary ────────────────────────────────────────────────────
    if (payload.summaryRows && payload.summaryRows.length > 0) {
      var summarySheet = ss.getSheetByName('Orders Summary');

      // Write header if sheet is empty
      if (summarySheet.getLastRow() === 0) {
        summarySheet.appendRow([
          'Order ID', 'Customer ID', 'Total', 'Discount',
          'Note', 'Status', 'Created At'
        ]);
      }

      payload.summaryRows.forEach(function(row) {
        summarySheet.appendRow([
          row.orderId, row.customerId, row.total, row.discount,
          row.note, row.status, row.createdAt
        ]);
      });
    }

    // ── Order Details ─────────────────────────────────────────────────────
    if (payload.detailRows && payload.detailRows.length > 0) {
      var detailSheet = ss.getSheetByName('Order Details');

      // Write header if sheet is empty
      if (detailSheet.getLastRow() === 0) {
        detailSheet.appendRow([
          'Order ID', 'Item ID', 'Product Name', 'Qty', 'Unit Price',
          'Size', 'Ice Level', 'Sweet Level', 'Toppings', 'Item Total'
        ]);
      }

      payload.detailRows.forEach(function(row) {
        detailSheet.appendRow([
          row.orderId, row.itemId, row.productName, row.qty, row.unitPrice,
          row.size, row.iceLevel, row.sweetLevel, row.toppings, row.itemTotal
        ]);
      });
    }

    return ContentService
      .createTextOutput(JSON.stringify({ status: 'ok', inserted: payload.summaryRows.length }))
      .setMimeType(ContentService.MimeType.JSON);

  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ status: 'error', message: err.message }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}
```

---

## Step 3 — Deploy as Web App

1. Click **Deploy → New deployment**
2. Click the gear icon ⚙ next to "Type" → select **Web app**
3. Fill in:
   - **Description**: MoonPos Sync
   - **Execute as**: Me
   - **Who has access**: Anyone
4. Click **Deploy**
5. If prompted, click **Authorize access** → choose your Google account → allow permissions
6. Copy the **Web app URL** — it looks like:

   ```
   https://script.google.com/macros/s/AKfycb.../exec
   ```

> **Important:** Every time you edit the script you must click **Deploy → New deployment** (not "Manage deployments") to publish the new version.

---

## Step 4 — Configure in MoonPos

1. Open MoonPos → **Settings**
2. Scroll to the **Google Sheets Sync** section
3. Paste the Web App URL into the field and tap **Save URL**
4. Tap **Sync Orders** to run the first sync

After a successful sync, the status line shows:
> *Synced N orders on DD-MM-YYYY HH:MM*

---

## How Incremental Sync Works

- The app tracks the **last synced order ID** in local storage (`SharedPreferences`)
- Each sync only sends orders whose ID is **greater than** the last synced ID
- Re-tapping Sync when there are no new orders does nothing and shows *"No new orders to sync."*
- The order ID counter never resets (auto-increment), so there are **no duplicate rows**

---

## Data Layout

### Orders Summary sheet

| Column | Description |
|---|---|
| Order ID | Unique order identifier |
| Customer ID | Customer ID (blank if walk-in) |
| Total | Total amount before discount |
| Discount | Discount amount |
| Note | Order note |
| Status | `pending` / `completed` / `cancelled` |
| Created At | Local time, format `dd-MM-yyyy HH:mm:ss` |

### Order Details sheet

| Column | Description |
|---|---|
| Order ID | Links back to Orders Summary |
| Item ID | Unique order item identifier |
| Product Name | Name of the product |
| Qty | Quantity ordered |
| Unit Price | Base price of the product |
| Size | Size label (e.g. "Large"), blank if none |
| Ice Level | Ice level label, blank if none |
| Sweet Level | Sweet level label, blank if none |
| Toppings | Comma-separated list, e.g. "Pearl x2, Jelly x1" |
| Item Total | Total for this line including size delta and toppings |

---

## Troubleshooting

| Problem | Fix |
|---|---|
| "HTTP 302" or redirect error | Make sure the URL ends with `/exec`, not `/dev` |
| "Apps Script returned an error" | Open Apps Script → Executions tab to see the error detail |
| Rows not appearing in sheet | Verify sheet names are exactly `Orders Summary` and `Order Details` |
| "You do not have permission" | Re-deploy with **Who has access: Anyone** |
| Sync button always disabled | Paste the URL and tap **Save URL** first |
| Want to re-sync all orders | In app storage, clear `sheets_sync_last_order_id` (or do a factory reset) |
