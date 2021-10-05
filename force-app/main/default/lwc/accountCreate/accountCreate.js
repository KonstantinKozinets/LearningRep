import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountCreate extends LightningElement {
    @track isLoading = true;
    @api objectApiName;
    @api fields;

    get validateLoading() {
        return this.isLoading;
    }

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Account created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(evt);
        this.isLoading = false;
        this.handleBack();
    }

    handleBack() {
        this.dispatchEvent(new CustomEvent('accountcreationback'));
    }

    handleProcessing() {
        this.isLoading = true;
    }

    handleLoad() {
        this.isLoading = false;
    }

}