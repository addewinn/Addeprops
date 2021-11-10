global class InvokePlatformEvent  
{
	@InvocableMethod(label='Publish New Addeprop Event' description='Fires the NewAddeprop Platform event for ensuring addeprops are receiving streaming inputs' Category='Addeprop__c')
	public static void doPublishPlatformEvent()
	{
		NewAddeprop__e notification = new NewAddeprop__e();
		Database.SaveResult result = EventBus.publish(notification);
		if(!result.isSuccess())
		{
			for(Database.Error err : result.getErrors())
			{
				System.debug(LoggingLevel.ERROR,err.getStatusCode() + ' | ' + err.getMessage());
			}
		}
	}
}