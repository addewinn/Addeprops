public class Emoji  
{
	public String name;
	public String unified;
	public String non_qualified;
	public String docomo;
	public String au;
	public String softbank;
	public String google;
	public String image;
	public Integer sheet_x;
	public Integer sheet_y;
	public String short_name;
	public List<String> short_names;
	//public Object text;
	//public Object texts;
	public String category;
	public String subcategory;
	public Integer sort_order;
	public String added_in;
	public Boolean has_img_apple;
	public Boolean has_img_google;
	public Boolean has_img_twitter;
	public Boolean has_img_facebook;

	public static List<Emoji> parse(String json) 
	{
		return (List<Emoji>) System.JSON.deserialize(json, List<Emoji>.class);
	}

	public static String getEmojiJson()
	{
		StaticResource resource = [Select Id, Name,SystemModStamp
									From StaticResource
									Where Name = 'addeprop'
									Limit 1];
		return extractEmojiJson(resource);
	}

	private static String extractEmojiJson(StaticResource resource)
	{
		String results = '';
		String urlFile = '/resource/'
						+ String.valueOf(((DateTime)resource.get('SystemModStamp')).getTime())
						+ '/' 
						+ resource.get('Name')
						+ '/json/emoji.json';
		PageReference fileRef = new PageReference(urlFile);
		return fileRef.getContent().toString();
	}

	public static void doPost()
	{
		List<EmojiData__c> data = new List<EmojiData__c>();
		Map<String,EmojiData__c> existingData = getExistingEmojiData();
		for(Emoji em : Emoji.parse(Emoji.getEmojiJson()))
		{
			if(!existingData.containsKey(em.name))
			{
				data.add(prepareNewEmoji(em));

			}
		}
		if(!data.isEmpty())
		{
			Database.insert(data,false);
		}
	}

	public static Map<String,EmojiData__c> getExistingEmojiData()
	{
		Map<String,EmojiData__c> results = new Map<String,EmojiData__c>();
		for(List<EmojiData__c> recs : [Select Id, Name, Category__c,Subcategory__c
										From EmojiData__c 
										Order By SortOrder__c ASC])
		{
			if(!recs.isEmpty())
			{
				for(EmojiData__c ed : recs)
				{
					results.put(ed.Name,ed);
				}
			}
		}
		return results;
	}

	private static EmojiData__c prepareNewEmoji(Emoji em)
	{
		EmojiData__c ed = new EmojiData__c();
		ed.Name = em.name;
		ed.Unified__c = em.unified;
		ed.Category__c = em.category;
		ed.SubCategory__c = em.subcategory;
		ed.SortOrder__c = em.sort_order;
		ed.softbank__c = em.softbank;
		ed.ShortNames__c = em.short_name;
		ed.SheetY__c = em.sheet_y;
		ed.SheetX__c = em.sheet_x;
		ed.NonQualified__c = em.non_qualified;
		ed.Image__c = em.image;
		ed.HasTwitterImage__c = em.has_img_twitter;
		ed.HasGoogleImage__c = em.has_img_google;
		ed.HasFacebookImage__c = em.has_img_facebook;
		ed.HasAppleImage__c = em.has_img_apple;
		ed.Google__c = em.google;
		ed.docomo__c = em.docomo;
		ed.au__c = em.au;
		ed.AddedIn__c = em.added_in;
		return ed;
	}
}