package com.grownited.service;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.grownited.entity.ExpenseEntity;
import com.grownited.entity.IncomeEntity;
import com.grownited.entity.UserEntity;
import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

@Service
public class ReportPdfService {

    // ── Palette ────────────────────────────────────────────────────────────────
    private static final Color COL_HEADER_BG   = new Color(30,  41,  59);   // slate-800
    private static final Color COL_HEADER_FG   = Color.WHITE;
    private static final Color COL_INCOME_BG   = new Color(240, 253, 244);  // green-50
    private static final Color COL_INCOME_FG   = new Color(22,  101, 52);   // green-800
    private static final Color COL_EXPENSE_BG  = new Color(255, 241, 242);  // rose-50
    private static final Color COL_EXPENSE_FG  = new Color(159, 18,  57);   // rose-800
    private static final Color COL_ALT_ROW     = new Color(248, 250, 252);  // slate-50
    private static final Color COL_SUMMARY_BG  = new Color(241, 245, 249);  // slate-100
    private static final Color COL_TOTALS_BG   = new Color(30,  41,  59);   // slate-800
    private static final Color COL_BORDER      = new Color(203, 213, 225);  // slate-300
    private static final Color COL_NET_POS     = new Color(22,  101, 52);   // green-800
    private static final Color COL_NET_NEG     = new Color(159, 18,  57);   // rose-800

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("dd MMM yyyy");

    // ── Fonts ──────────────────────────────────────────────────────────────────
    private static final Font FONT_TITLE     = FontFactory.getFont(FontFactory.HELVETICA_BOLD,  16, Color.WHITE);
    private static final Font FONT_META      = FontFactory.getFont(FontFactory.HELVETICA,       9,  new Color(148, 163, 184));
    private static final Font FONT_SECTION   = FontFactory.getFont(FontFactory.HELVETICA_BOLD,  10, new Color(30, 41, 59));
    private static final Font FONT_SUMMARY_V = FontFactory.getFont(FontFactory.HELVETICA_BOLD,  11, new Color(30, 41, 59));
    private static final Font FONT_SUMMARY_L = FontFactory.getFont(FontFactory.HELVETICA,       8,  new Color(100,116,139));
    private static final Font FONT_TH        = FontFactory.getFont(FontFactory.HELVETICA_BOLD,  9,  COL_HEADER_FG);
    private static final Font FONT_CELL      = FontFactory.getFont(FontFactory.HELVETICA,       9,  new Color(30, 41, 59));
    private static final Font FONT_INCOME    = FontFactory.getFont(FontFactory.HELVETICA_BOLD,  9,  COL_INCOME_FG);
    private static final Font FONT_EXPENSE   = FontFactory.getFont(FontFactory.HELVETICA_BOLD,  9,  COL_EXPENSE_FG);
    private static final Font FONT_TOTAL_LBL = FontFactory.getFont(FontFactory.HELVETICA_BOLD,  9,  Color.WHITE);
    private static final Font FONT_TOTAL_VAL = FontFactory.getFont(FontFactory.HELVETICA_BOLD,  9,  Color.WHITE);
    private static final Font FONT_NET_POS_F = FontFactory.getFont(FontFactory.HELVETICA_BOLD,  9,  COL_NET_POS);
    private static final Font FONT_NET_NEG_F = FontFactory.getFont(FontFactory.HELVETICA_BOLD,  9,  COL_NET_NEG);

    // ──────────────────────────────────────────────────────────────────────────

    public byte[] buildDateWiseTransactionsPdf(
            UserEntity user,
            LocalDate from,
            LocalDate to,
            List<IncomeEntity> incomes,
            List<ExpenseEntity> expenses,
            Map<Integer, String> categoryMap) { 

        try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {

            Document document = new Document(PageSize.A4, 36, 36, 36, 36);
            PdfWriter.getInstance(document, out);
            document.open();

            // ── 1. Header Banner ───────────────────────────────────────────────
            addHeaderBanner(document, user, from, to);

            document.add(spacer(10));

            // ── 2. Summary Cards ──────────────────────────────────────────────
            BigDecimal totalIncome  = incomes.stream()
                    .map(IncomeEntity::getAmount).filter(a -> a != null).reduce(BigDecimal.ZERO, BigDecimal::add);
            BigDecimal totalExpense = expenses.stream()
                    .map(ExpenseEntity::getAmount).filter(a -> a != null).reduce(BigDecimal.ZERO, BigDecimal::add);
            BigDecimal netSavings   = totalIncome.subtract(totalExpense);

            addSummaryCards(document, totalIncome, totalExpense, netSavings,
                    incomes.size(), expenses.size());

            document.add(spacer(12));

            // ── 3. Section label ──────────────────────────────────────────────
            Paragraph label = new Paragraph("Transaction Details", FONT_SECTION);
            label.setSpacingAfter(4);
            document.add(label);

            // ── 4. Transactions Table ─────────────────────────────────────────
            addTransactionsTable(document, incomes, expenses, totalIncome, totalExpense, netSavings, categoryMap);

            // ── 5. Footer note ────────────────────────────────────────────────
            document.add(spacer(8));
            Paragraph footer = new Paragraph(
                    "Generated on " + LocalDate.now().format(DATE_FMT) + "  ·  Grownited Finance",
                    FontFactory.getFont(FontFactory.HELVETICA, 7, new Color(148, 163, 184)));
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);

            document.close();
            return out.toByteArray();

        } catch (Exception ex) {
            throw new RuntimeException("Failed to generate PDF", ex);
        }
    }

    // ── Header Banner ──────────────────────────────────────────────────────────
    private void addHeaderBanner(Document doc, UserEntity user, LocalDate from, LocalDate to)
            throws Exception {

        PdfPTable banner = new PdfPTable(1);
        banner.setWidthPercentage(100);

        PdfPCell cell = new PdfPCell();
        cell.setBackgroundColor(COL_HEADER_BG);
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setPadding(16);

        Paragraph title = new Paragraph("Income / Expense Report", FONT_TITLE);
        title.setAlignment(Element.ALIGN_LEFT);
        cell.addElement(title);

        String meta = "Prepared for: " + fullName(user)
                + "   |   Period: " + from.format(DATE_FMT) + " – " + to.format(DATE_FMT);
        Paragraph metaPara = new Paragraph(meta, FONT_META);
        metaPara.setAlignment(Element.ALIGN_LEFT);
        metaPara.setSpacingBefore(4);
        cell.addElement(metaPara);

        banner.addCell(cell);
        doc.add(banner);
    }

    // ── Summary Cards ──────────────────────────────────────────────────────────
    private void addSummaryCards(Document doc,
            BigDecimal totalIncome, BigDecimal totalExpense, BigDecimal netSavings,
            int incomeCount, int expenseCount) throws Exception {

        PdfPTable cards = new PdfPTable(3);
        cards.setWidthPercentage(100);
        cards.setWidths(new float[]{1f, 1f, 1f});
        cards.setSpacingAfter(0);

        cards.addCell(summaryCard("Total Income",
                "₹ " + fmt(totalIncome), incomeCount + " transaction(s)",
                new Color(220, 252, 231), COL_INCOME_FG, new Color(187, 247, 208)));

        cards.addCell(summaryCard("Total Expenses",
                "₹ " + fmt(totalExpense), expenseCount + " transaction(s)",
                new Color(255, 228, 230), COL_EXPENSE_FG, new Color(254, 205, 211)));

        Color netBg  = netSavings.compareTo(BigDecimal.ZERO) >= 0
                ? new Color(219, 234, 254) : new Color(255, 228, 230);
        Color netFg  = netSavings.compareTo(BigDecimal.ZERO) >= 0
                ? new Color(30, 64, 175) : COL_EXPENSE_FG;
        Color netBrd = netSavings.compareTo(BigDecimal.ZERO) >= 0
                ? new Color(191, 219, 254) : new Color(254, 205, 211);
        String netSign = netSavings.compareTo(BigDecimal.ZERO) >= 0 ? "+" : "";
        cards.addCell(summaryCard("Net Savings",
                netSign + "₹ " + fmt(netSavings), "Income minus Expenses",
                netBg, netFg, netBrd));

        doc.add(cards);
    }

    private PdfPCell summaryCard(String label, String value, String sub,
            Color bg, Color fg, Color borderColor) {

        PdfPCell cell = new PdfPCell();
        cell.setBackgroundColor(bg);
        cell.setBorderColor(borderColor);
        cell.setBorderWidth(1.2f);
        cell.setPadding(10);

        Font labelFont = FontFactory.getFont(FontFactory.HELVETICA, 7, new Color(100, 116, 139));
        Font valueFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 13, fg);
        Font subFont   = FontFactory.getFont(FontFactory.HELVETICA, 7, new Color(100, 116, 139));

        cell.addElement(new Paragraph(label.toUpperCase(), labelFont));
        Paragraph valPara = new Paragraph(value, valueFont);
        valPara.setSpacingBefore(2);
        cell.addElement(valPara);
        Paragraph subPara = new Paragraph(sub, subFont);
        subPara.setSpacingBefore(2);
        cell.addElement(subPara);

        return cell;
    }

    // ── Transactions Table ─────────────────────────────────────────────────────
    private void addTransactionsTable(Document doc,
            List<IncomeEntity> incomes, List<ExpenseEntity> expenses,
            BigDecimal totalIncome, BigDecimal totalExpense, BigDecimal netSavings,
            Map<Integer, String> categoryMap)   // ← ADD THIS
            throws Exception {

        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{2f, 1.4f, 2f, 3.2f, 1.8f});
        table.setHeaderRows(1);

        // Column headers
        for (String h : new String[]{"Date", "Type", "Category / Source", "Description", "Amount (₹)"}) {
            PdfPCell hCell = new PdfPCell(new Phrase(h, FONT_TH));
            hCell.setBackgroundColor(COL_HEADER_BG);
            hCell.setBorderColor(COL_HEADER_BG);
            hCell.setPadding(7);
            hCell.setHorizontalAlignment(Element.ALIGN_LEFT);
            table.addCell(hCell);
        }

        // Build rows
        List<Row> rows = new ArrayList<>();
        for (IncomeEntity i : incomes) {
            rows.add(new Row(i.getIncomeDate(), "Income",
                    safe(i.getIncomeSource()), safe(i.getPaymentMode()), i.getAmount()));
        }
        for (ExpenseEntity e : expenses) {
            String catName = (e.getCategoryId() != null && categoryMap.containsKey(e.getCategoryId()))
                    ? categoryMap.get(e.getCategoryId())
                    : "Uncategorised";
            rows.add(new Row(e.getExpenseDate(), "Expense",
                    catName,                        // ← was "Category " + e.getCategoryId()
                    safe(e.getDescription()), e.getAmount()));
        }
        rows.sort(Comparator.comparing(r -> r.date() != null ? r.date() : LocalDate.MIN));

        int rowIdx = 0;
        for (Row r : rows) {
            boolean isIncome  = "Income".equals(r.type());
            boolean isAltRow  = (rowIdx % 2 == 1);

            Color rowBg  = isIncome  ? COL_INCOME_BG
                         : isAltRow  ? COL_ALT_ROW
                         :             Color.WHITE;
            Color rowFg  = isIncome  ? COL_INCOME_FG : new Color(30, 41, 59);
            Font  cellFt = isIncome  ? FONT_INCOME
                         : "Expense".equals(r.type()) ? FONT_EXPENSE
                         : FONT_CELL;

            addDataCell(table, safeDate(r.date()), FONT_CELL, rowBg);
            addBadgeCell(table, r.type(), isIncome ? COL_INCOME_FG : COL_EXPENSE_FG,
                    isIncome ? new Color(187, 247, 208) : new Color(254, 205, 211), rowBg);
            addDataCell(table, r.categoryOrSource(), FONT_CELL, rowBg);
            addDataCell(table, r.description(), FONT_CELL, rowBg);
            addAmountCell(table, r.amount(), isIncome, rowBg);

            rowIdx++;
        }

        // Totals row
        addTotalsRow(table, totalIncome, totalExpense, netSavings);

        doc.add(table);
    }

    private void addDataCell(PdfPTable table, String text, Font font, Color bg) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setBackgroundColor(bg);
        cell.setBorderColor(COL_BORDER);
        cell.setBorderWidth(0.5f);
        cell.setPadding(6);
        table.addCell(cell);
    }

    private void addBadgeCell(PdfPTable table, String text, Color fg, Color badgeBg, Color rowBg) {
        Font f = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8, fg);
        PdfPCell inner = new PdfPCell(new Phrase(text, f));
        inner.setBackgroundColor(badgeBg);
        inner.setBorderColor(badgeBg);
        inner.setPadding(3);
        inner.setHorizontalAlignment(Element.ALIGN_CENTER);

        // Wrap in outer cell matching row bg
        PdfPCell outer = new PdfPCell();
        outer.setBackgroundColor(rowBg);
        outer.setBorderColor(COL_BORDER);
        outer.setBorderWidth(0.5f);
        outer.setPadding(4);
        // Render badge inline via phrase fallback (OpenPDF doesn't support nested cells easily)
        outer.setPhrase(new Phrase(text, f));
        outer.setHorizontalAlignment(Element.ALIGN_LEFT);
        table.addCell(outer);
    }

    private void addAmountCell(PdfPTable table, BigDecimal amount, boolean isIncome, Color rowBg) {
        String sign = isIncome ? "+ " : "- ";
        Font f = isIncome ? FONT_INCOME : FONT_EXPENSE;
        PdfPCell cell = new PdfPCell(new Phrase(sign + fmt(amount), f));
        cell.setBackgroundColor(rowBg);
        cell.setBorderColor(COL_BORDER);
        cell.setBorderWidth(0.5f);
        cell.setPadding(6);
        cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        table.addCell(cell);
    }

    private void addTotalsRow(PdfPTable table,
            BigDecimal totalIncome, BigDecimal totalExpense, BigDecimal netSavings) {

        // Label cell spans 4 columns
        PdfPCell labelCell = new PdfPCell(new Phrase("Totals", FONT_TOTAL_LBL));
        labelCell.setColspan(2);
        labelCell.setBackgroundColor(COL_TOTALS_BG);
        labelCell.setBorderColor(COL_TOTALS_BG);
        labelCell.setPadding(7);
        table.addCell(labelCell);

        // Income total
        PdfPCell incCell = new PdfPCell(new Phrase("In: ₹ " + fmt(totalIncome), FONT_TOTAL_VAL));
        incCell.setBackgroundColor(COL_TOTALS_BG);
        incCell.setBorderColor(COL_TOTALS_BG);
        incCell.setPadding(7);
        table.addCell(incCell);

        // Expense total
        PdfPCell expCell = new PdfPCell(new Phrase("Out: ₹ " + fmt(totalExpense), FONT_TOTAL_VAL));
        expCell.setBackgroundColor(COL_TOTALS_BG);
        expCell.setBorderColor(COL_TOTALS_BG);
        expCell.setPadding(7);
        table.addCell(expCell);

        // Net
        boolean positive = netSavings.compareTo(BigDecimal.ZERO) >= 0;
        String netStr = (positive ? "▲ " : "▼ ") + "₹ " + fmt(netSavings.abs());
        Font netFont = positive ? FONT_NET_POS_F : FONT_NET_NEG_F;
        // Override to white on dark bg
        Font netWhite = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, Color.WHITE);
        PdfPCell netCell = new PdfPCell(new Phrase(netStr, netWhite));
        netCell.setBackgroundColor(COL_TOTALS_BG);
        netCell.setBorderColor(COL_TOTALS_BG);
        netCell.setPadding(7);
        netCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        table.addCell(netCell);
    }

    // ── Helpers ────────────────────────────────────────────────────────────────

    private static Paragraph spacer(float height) {
        Paragraph p = new Paragraph(" ");
        p.setLeading(height);
        return p;
    }

    private static String fmt(BigDecimal v) {
        if (v == null) return "0.00";
        return String.format("%,.2f", v);
    }

    private static String safe(String s) {
        return (s == null || s.isBlank()) ? "—" : s;
    }

    private static String safeDate(LocalDate d) {
        return d != null ? d.format(DATE_FMT) : "—";
    }

    private static String fullName(UserEntity u) {
        if (u == null) return "Unknown";
        String fn = u.getFirstName() != null ? u.getFirstName() : "";
        String ln = u.getLastName()  != null ? u.getLastName()  : "";
        return (fn + " " + ln).trim();
    }

    // ── Row record ─────────────────────────────────────────────────────────────
    private record Row(
            LocalDate date,
            String type,
            String categoryOrSource,
            String description,
            BigDecimal amount) {}
}