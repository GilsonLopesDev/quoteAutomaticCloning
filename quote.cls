public static void quoteAutomaticCloning(){ 
        list<string> QId = new List<string>(); 
        for(Quote q: (List<Quote>)Trigger.New){ 
            system.debug(' >>> '+ q.Status); 
            if(q.Status == 'Rejected'){ 
                CloneQuoteLController.cloneQuote(q.Id,true); 
                list<string> emailIds = new list<string>(); 
                contract con = new contract(); 
                if(q.ContractId != null){ 
                    con = [select id, Owner.Email from Contract where id=: q.ContractId];  
                    emailIds.add(con.Owner.Email); 
                } 
                else if(q.Owner != null) { 
                    emailIds.add(q.Owner.Email); 
                } 
                EmailTemplate templateId = [Select id from EmailTemplate where name = 'Clone Cotação Rejeitada.']; 
            
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                mail.setTemplateID(templateId.Id); 
                mail.setTargetObjectId( UserInfo.getUserId() ); 
                 
                mail.setToAddresses(emailIds); 
                mail.setSaveAsActivity(false); 
 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
            } 
        } 
         
    }