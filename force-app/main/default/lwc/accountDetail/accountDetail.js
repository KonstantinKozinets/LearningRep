import { LightningElement, api, track } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountDetail extends LightningElement {
    @track error;
    @track isLoading = false;
    @api fields;
    @api accountId;

    handleDelete() {
        this.isLoading = true;
        deleteRecord(this.accountId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );
                this.isLoading = false;
                this.handleBack();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
                this.isLoading = false;
            });
    }

    handleBack() {
        this.dispatchEvent(new CustomEvent('accountdetailback'));
    }

    handleNew() {
        this.dispatchEvent(new CustomEvent('accountdetailnew'));
    }

}