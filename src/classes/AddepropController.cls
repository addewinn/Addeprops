public with sharing class AddepropController  
{
	@AuraEnabled
	public static Addeprop__c getAddeprop(String recordId)
	{
		Addeprop__c prop = new Addeprop__c();
		try{
			prop = [Select Id, Name, Reason__c,Sender__c,UserName__c,CreatedDate
					From Addeprop__c Where Id =: recordId Limit 1];
		}catch(Exception ex){
			System.debug(LoggingLevel.ERROR,ex.getStackTraceString());
		}
		return prop;
	}

	@AuraEnabled
	public static List<PropRecipient__c> getPropRecipients(String recordId)
	{
		List<PropRecipient__c> results = new List<PropRecipient__c>();
		try{
			results = [Select Id, Addeprop__c,Name, RecipientName__c,UserName__c
						From PropRecipient__c
						WHere Addeprop__c =:recordId
						Order By CreatedDate ASC];
		}catch(Exception ex){
			System.debug(LoggingLevel.ERROR,ex.getStackTraceString());
		}
		return results;
	}

	@AuraEnabled
	public static List<Emoji__c> getPropEmojis(String recordId)
	{
		List<Emoji__c> results = new List<Emoji__c>();
		try{
			results = [Select Id,Character__c,Type__c
						From Emoji__c
						Where Addeprop__c =: recordId
						Order By CreatedDate ASC];
		}catch(Exception ex){
			System.debug(LoggingLevel.ERROR,ex.getStackTraceString());
		}
		return results;
	}

	@AuraEnabled
	public static List<AddeProp> getAllAddeprops()
	{
		List<AddeProp> results = new List<AddeProp>();
		List<AddeProp__c> props = new List<AddeProp__c>();
		for(List<Addeprop__c> recs :[Select Id, Name, Reason__c,Sender__c,UserName__c,CreatedDate
										From Addeprop__c
										Order By CreatedDate DESC])
		{
			if(!recs.isEmpty())
			{
				props.addAll(recs);
			}
		}
		if(!props.isEmpty())
		{
			Map<Id,List<PropRecipient__c>> recipsMap = getRecipsMap(propIdSet(props));
			Map<Id,List<Emoji__c>> emojiMap = getEmojiMap(propIdSet(props));
			for(AddeProp__c a : props)
			{
				List<Emoji__c> emojis = emojiMap.containsKey(a.Id) ? emojiMap.get(a.Id) : new List<Emoji__c>();
				List<PropRecipient__c> recips = recipsMap.containsKey(a.Id) ? recipsMap.get(a.Id) : new List<PropRecipient__c>();
				results.add(new AddeProp(a,recips,emojis));
			}
		}
		return results;
	}

	public static Map<Id,List<PropRecipient__c>> getRecipsMap(Set<Id> props)
	{
		Map<Id,List<PropRecipient__c>> results = new Map<Id,List<PropRecipient__c>>();
		for(List<PropRecipient__c> recs :[Select Id, Addeprop__c,Name, RecipientName__c,UserName__c
											From PropRecipient__c
											WHere Addeprop__c IN:props
											Order By AddeProp__c ASC])
		{
			if(!recs.isEmpty())
			{
				for(PropRecipient__c p : recs)
				{
					if(results.containsKey(p.AddeProp__c))
					{
						results.get(p.AddeProp__c).add(p);
					} else{
						results.put(p.AddeProp__c, new List<PropRecipient__c>{p});
					}
				}
			}
		}
		return results;
	}

	public static Map<Id,List<Emoji__c>> getEmojiMap(Set<Id> props)
	{
		Map<Id,List<Emoji__c>> results = new Map<Id,List<Emoji__c>>();
		for(List<Emoji__c> recs :[Select Id,Character__c,Type__c,AddeProp__c
									From Emoji__c
									Where Addeprop__c IN: props
									Order By Addeprop__c ASC])
		{
			if(!recs.isEmpty())
			{
				for(Emoji__c p : recs)
				{
					if(results.containsKey(p.AddeProp__c))
					{
						results.get(p.AddeProp__c).add(p);
					} else{
						results.put(p.AddeProp__c, new List<Emoji__c>{p});
					}
				}
			}
		}
		return results;
	}

	public static Set<Id> propIdSet(List<AddeProp__c> props)
	{
		Set<Id> results = new Set<Id>();
		for(AddeProp__c a : props)
		{
			results.add(a.Id);
		}
		return results;
	}
	
	@AuraEnabled
	public static Map<String,EmojiData__c> getEmojiData()
	{
		return Emoji.getExistingEmojiData();
	}

	public class AddeProp
	{
		@AuraEnabled public String userName { get; set; }
		@AuraEnabled public String sender { get; set; }
		@AuraEnabled public String reason { get; set; }
		@AuraEnabled public List<PropRecipient> recipients { get; set; }
		@AuraEnabled public List<PropEmoji> emojis { get; set; }
		public AddeProp(Addeprop__c prop,List<PropRecipient__c> recips,List<Emoji__c> emojiList)
		{
			this.userName = prop.UserName__c;
			this.sender = prop.Sender__c;
			this.reason = prop.Reason__c;
			this.recipients = new List<PropRecipient>();
			this.emojis = new List<PropEmoji>();
			if(!recips.isEmpty())
			{
				for(PropRecipient__c pr : recips)
				{
					recipients.add(new PropRecipient(pr));
				}
			}
			if(!emojiList.isEmpty())
			{
				for(Emoji__c e : emojiList)
				{
					emojis.add(new PropEmoji(e));
				}
			}
		}
		public AddeProp() {}
	}

	public class PropRecipient
	{
		@AuraEnabled public String name { get; set; }
		@AuraEnabled public String userName { get; set; }
		public PropRecipient(PropRecipient__c pr)
		{
			this.name = pr.RecipientName__c;
			this.userName = pr.UserName__c;
		}
		public PropRecipient() {}
	}

	public class PropEmoji
	{
		@AuraEnabled public String character { get; set; }
		@AuraEnabled public String type { get; set; }
		public PropEmoji(Emoji__c em)
		{
			this.character = em.Character__c;
			this.type = em.Type__c;
		}
		public PropEmoji() {}
	}
}