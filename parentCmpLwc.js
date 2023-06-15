import { LightningElement,wire,track } from 'lwc';
import retrieveContactRecords from '@salesforce/apex/lwcaccountrelatedcontactcontroller.retrieveContactRecords';

export default class ParentCmpLwc extends LightningElement {
    @track accountId;
    @track records;
    @track errorMsg;    
 
    @wire (retrieveContactRecords, {accId:'$accountId'})
      wireConRecord({error,data}){
        if(data){
          this.records = data;     
          this.errorMsg = undefined;    
        }else{         
          this.errorMsg = error;
          this.records = undefined;
        }
      }
 
    handleChangeAction(event){
      this.accountId = event.detail;
      window.console.log('accountId ' + this.accountId);
    }
}