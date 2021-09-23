import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountCreate extends LightningElement {
    @api objectApiName;
    @api fields;
    @api isAccounts;
    @api isAccountCreate;

    @api get validateCondition() { return (isAccounts == 'false' && isAccountCreate == 'true');}

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Account created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(evt);
    }

}