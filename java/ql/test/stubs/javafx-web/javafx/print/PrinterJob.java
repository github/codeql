// Generated automatically from javafx.print.PrinterJob for testing purposes

package javafx.print;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.ReadOnlyObjectProperty;
import javafx.print.JobSettings;
import javafx.print.PageLayout;
import javafx.print.Printer;
import javafx.scene.Node;
import javafx.stage.Window;

public class PrinterJob
{
    protected PrinterJob() {}
    public JobSettings getJobSettings(){ return null; }
    public String toString(){ return null; }
    public boolean endJob(){ return false; }
    public boolean printPage(Node p0){ return false; }
    public boolean printPage(PageLayout p0, Node p1){ return false; }
    public boolean showPageSetupDialog(Window p0){ return false; }
    public boolean showPrintDialog(Window p0){ return false; }
    public final ObjectProperty<Printer> printerProperty(){ return null; }
    public final Printer getPrinter(){ return null; }
    public final PrinterJob.JobStatus getJobStatus(){ return null; }
    public final ReadOnlyObjectProperty<PrinterJob.JobStatus> jobStatusProperty(){ return null; }
    public final void setPrinter(Printer p0){}
    public static PrinterJob createPrinterJob(){ return null; }
    public static PrinterJob createPrinterJob(Printer p0){ return null; }
    public void cancelJob(){}
    static public enum JobStatus
    {
        CANCELED, DONE, ERROR, NOT_STARTED, PRINTING;
        private JobStatus() {}
    }
}
