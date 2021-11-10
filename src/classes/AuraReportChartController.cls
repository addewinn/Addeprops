/**
* @author Kevin Winn
* @date 05/20/2021
* @group Controllers - Aura
* @description 
**/
public without sharing class AuraReportChartController 
{
    /**
    * @author Kevin Winn
    * @date May 16, 2020 
    * @description A description for this method
    */
    @AuraEnabled
    public static String getReportData(string reportId)
    {
        try
        {   
            Report sfReport = [Select Id From Report Where Id =: reportId Limit 1];
            Reports.ReportResults results = Reports.ReportManager.runReport(sfReport.Id, true);
            return JSON.serializePretty(results);
        }
        catch(Exception ex)
        {
            throw new AuraHandledException('Something went wrong...' + '\n' + 
                                            'Message: ' + ex.getMessage() + '\n' + 
                                            'Type: ' + ex.getTypeName() + '\n' +
                                            'Cause: ' + ex.getCause() + '\n' + 
                                            'Trace: ' + ex.getStackTraceString() + '\n' +
                                            'Report Id: ' + reportId);
        }
    }

	/**
    * @author Kevin Winn
    * @date May 16, 2020 
    * @description A description for this method
    */
    @AuraEnabled
    public static Boolean reportDataIsAccessible()
    {
        if(Schema.SObjectType.Report.isAccessible())
		{
			return true;
		}
        return false;
    }
}