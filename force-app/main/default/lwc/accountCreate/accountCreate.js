import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountCreate extends LightningElement {
    @api objectApiName;
    @api fields;
    isCreated = false;

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Account created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(evt);
        this.isCreated = true;
    }

    handleButtonBackClick(evt) {
        const event = new CustomEvent('buttonBackClick', {
            detail: evt.detail
        });

        this.dispatchEvent(event);
    }
}