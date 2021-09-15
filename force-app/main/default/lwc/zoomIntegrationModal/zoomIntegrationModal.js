import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import integrate from '@salesforce/apex/ZoomIntegration.integrate';
import { reduceErrors } from 'c/ldsUtils';

export default class ZoomIntegrationModal extends LightningElement {
    @api recordId;
    @track value;

    get errors() {
        return (this.error) ?
            reduceErrors(this.error) : [];
    }

    get options() {
        return [
            { label: 'Mobile', value: 'Mobile' },
            { label: 'Office', value: 'Office' },
            { label: 'Home', value: 'Home' },
            { label: 'Fax', value: 'Fax'}
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

    confirmInt() {
        integrate({ phoneType: this.value, zRecordId: this.recordId })
            .then(result => {
                const toastEvent = new ShowToastEvent({
                    title: "Status: " + result,
                    message: "Phone Type: " + this.value + ". Campaign: " + this.recordId,
                    variant: "warning"
                });
                this.dispatchEvent(toastEvent);
            })
            .catch(error => {
                this.error = error;
                const toastEvent = new ShowToastEvent({
                    title: "Error",
                    message: "Phone Type: " + this.value + ". Campaign: " + this.recordId,
                    variant: "warning"
                });
                this.dispatchEvent(toastEvent);
            });
    }

}