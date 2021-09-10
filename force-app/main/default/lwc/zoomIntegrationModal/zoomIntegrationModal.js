import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import integrate from '@salesforce/apex/ZoomIntegration.integrate';
import { reduceErrors } from 'c/ldsUtils';

export default class ZoomIntegrationModal extends LightningElement {
    @api recordId;
    @track value;
    @track eStatus;

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
                this.eStatus = result;
            })
            .catch(error => {
                this.error = error;
                this.eStatus = "Error";
            });
        const toastEvent = new ShowToastEvent({
            title: "Status: " + this.eStatus,
            message: "Phone Type: " + this.value + ". Campaign: " + this.recordId,
            variant: "warning"
        });
        this.dispatchEvent(toastEvent);
    }

}