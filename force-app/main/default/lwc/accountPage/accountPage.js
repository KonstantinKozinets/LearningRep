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
    @track pageNumber = 1;
    @track pageCount;
    isFirst = false;
    isLast = false;
    isInvalid;

    handleAccountSelected(evt) {
        console.log("logged acc ID: ", evt.detail);
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
        return (this.isAccounts && !this.isAccountCreate && this.accounts && this.fields);
    }

    get validateConditionDetail() {
        return (!this.isAccounts && !this.isAccountCreate && this.selectedAccountId && this.accFields);
    }

    get validateConditionCreate() {
        return (!this.isAccounts && this.isAccountCreate && this.accFields);
    }

    get validateFirst() {
        return (this.isFirst && !this.isInvalid);
    }

    get validateLast() {
        return (this.isLast && !this.isInvalid);
    }

    handleLoad () {
        getAccountList({pageNumber: this.pageNumber})
        .then(result => {
            this.accounts = result.accounts;
            this.fields = result.fieldSet;
            this.accFields = result.accFields;
            this.isAccounts = true;
            this.isAccountCreate = false;
            this.pageNumber = result.pageNumber;
            this.pageCount = result.pageCount;

            if (result.pageNumber == 1) {
                this.isFirst = true;
            }
            if (result.pageNumber < 1) {
                this.isInvalid = true;
            }
            if (result.pageNumber == result.pageCount) {
                this.isLast = true;
            }
            if (result.pageNumber > this.pageCount) {
                this.isInvalid = true;
            }

            console.log('current page: ', result.pageNumber);
            console.log('accounts:', result.accounts);

            const toastEvent = new ShowToastEvent({
                title: "Success",
                message: "Records are loaded, total pages: " + result.pageCount,
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

    handleNext() {
        this.pageNumber = this.pageNumber + 1;
        console.log('next page', this.pageNumber);
        this.handleLoad();
    }

    handlePrevious() {
        this.pageNumber = this.pageNumber - 1;
        console.log('previous page', this.pageNumber);
        this.handleLoad();
    }
}