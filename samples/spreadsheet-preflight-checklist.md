# Spreadsheet Preflight Checklist

Use this before editing an important XLSX or XLSM workbook. Work on a copy and
record observations; do not "fix" anything during the inventory pass.

## File and calculation state

- [ ] Record the file type, size, modification time, and sheet count.
- [ ] Confirm whether the workbook contains macros or signed VBA.
- [ ] Record calculation mode: automatic, automatic except data tables, or manual.
- [ ] Check whether recalculation is forced on open or save.
- [ ] Identify external workbook links and data connections.

## Structure

- [ ] List visible, hidden, and very-hidden sheets.
- [ ] Record merged ranges and protected sheets.
- [ ] Find named ranges with missing or external references.
- [ ] Note tables, pivot tables, charts, and data-validation ranges.
- [ ] Check whether formulas differ unexpectedly inside repeated regions.

## Error and integrity signals

- [ ] Search formulas and cached values for `#REF!`, `#VALUE!`, `#DIV/0!`,
      `#NAME?`, `#NUM!`, `#N/A`, and `#SPILL!`.
- [ ] Find formulas that reference blank cells where a value is expected.
- [ ] Identify numbers stored as text and inconsistent date formats.
- [ ] Compare formula coverage across adjacent rows and columns.
- [ ] Record all findings before deciding whether recalculation is safe.

## Stop conditions

Stop and use an isolated copy if the workbook contains macros, external data
refreshes, protected business logic, digital signatures, or sensitive data.
Never upload a proprietary workbook to a public issue.

If the checklist reveals a risk that needs a read-only structure report,
[request a spreadsheet audit](https://github.com/soul-sol/verified-automation-services/issues/new?template=spreadsheet-audit.yml).
