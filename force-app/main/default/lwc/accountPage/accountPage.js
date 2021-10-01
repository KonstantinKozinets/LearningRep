import { LightningElement, track } from 'lwc';
import getAccountList from '@salesforce/apex/AccountFieldSet.getAccountList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountPage extends LightningElement {

    @track accounts;
    @track fields;
    @track accFields;
    isAccountCreate;
    isAccounts;
    selectedAccountId;

    handleAccountSelected(evt) {
        this.selectedAccountId = evt.detail;
        this.isAccounts = false;
        this.isAccountCreate = false;
    }

    handleAccountCreate() {
        this.isAccounts = false;
        this.isAccountCreate = true;
    }

    handleBack() {
        this.isAccounts = true;
        this.isAccountCreate = false;
    }

    get validateConditionTable() {
        return (this.isAccounts && !this.isAccountCreate);
    }

    get validateConditionDetail() {
        return (!this.isAccounts && !this.isAccountCreate);
    }

    get validateConditionCreate() {
        return (!this.isAccounts && this.isAccountCreate);
    }

    handleLoad () {
        getAccountList()
        .then(result => {
            this.accounts = result.accounts;
            this.fields = result.fieldSet;
            this.accFields = result.accFields;
            this.isAccounts = true;
            this.isAccountCreate = false;
            console.log(result.fieldSet);
            console.log(result.accFields);

            const toastEvent = new ShowToastEvent({
                title: "Success",
                message: "Records are loaded",
                variant: "success"
            });
            this.dispatchEvent(toastEvent);
        })
        .catch(error => {
            this.error = error;
            const toastEvent = new ShowToastEvent({
                title: "Error",
                message: "Error: " + error.message,
                variant: "error"
            });
            this.dispatchEvent(toastEvent);
        });
    }
}