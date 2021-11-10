<aura:application access="GLOBAL" extends="ltng:outApp" implements="ltng:allowGuestAccess"> 
	<ltng:require 
        scripts="{!$Resource.Chart_JS}" />
	<aura:dependency resource="c:Addeprops" type="COMPONENT"/>
</aura:application>