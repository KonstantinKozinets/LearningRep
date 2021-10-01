import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountCreate extends LightningElement {
    @api objectApiName;
    @api fields;

    handleSuccess(event) {
        console.log(2222);
        const evt = new ShowToastEvent({
            title: "Account created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(evt);
        this.handleBack();
    }

    handleBack() {
        this.dispatchEvent(new CustomEvent('accountcreationback'));
    }

}