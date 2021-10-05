import { LightningElement, track } from 'lwc';
import getAccountList from '@salesforce/apex/AccountFieldSet.getAccountList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountPage extends LightningElement {

    @track accFields;
    @track isLoading
    @track accData;
    @track error;
    isAccountCreate;
    isAccounts;
    selectedAccountId;
    pageNumber = 1;
    pageCount = 0;


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
        this.isLoading = true;
        this.handleLoad();
    }

    get validateLoading() {
        return this.isLoading;
    }

    get validateConditionTable() {
        return (
            this.isAccounts && !this.isAccountCreate && this.accData && this.accData.accounts && this.accData.fieldSet
        );
    }

    get validateConditionDetail() {
        return (
            !this.isAccounts && !this.isAccountCreate && this.selectedAccountId && this.accFields
        );
    }

    get validateConditionCreate() {
        return (!this.isAccounts && this.isAccountCreate && this.accFields);
    }

    get validateFirst() {
        return (this.pageNumber == 1 || this.pageNumber < 1 || this.pageNumber > this.pageCount);
    }

    get validateLast() {
        return (this.pageNumber == this.pageCount || this.pageNumber < 1 || this.pageNumber > this.pageCount);
    }

    handleLoad () {
        getAccountList({pageNumber: this.pageNumber})
        .then(result => {
            this.accData = result;
            this.isAccounts = true;
            this.isAccountCreate = false;
            this.pageNumber = result.pageNumber;
            this.pageCount = result.pageCount;
            this.accFields = result.accFields;

            // const toastEvent = new ShowToastEvent({
            //     title: "Success",
            //     message: "Current page: " + result.pageNumber + " of " + result.pageCount,
            //     variant: "success"
            // });

            // this.dispatchEvent(toastEvent);
            this.isLoading = false;
        })
        .catch(error => {
            this.error = error;
            const toastEvent = new ShowToastEvent({
                title: "Error",
                message: "Error: " + error.message,
                variant: "error"
            });
            this.dispatchEvent(toastEvent);
            this.isLoading = false;
        });
    }

    handleNext() {
        this.isLoading = true;
        this.pageNumber++;
        this.handleLoad();
    }

    handlePrevious() {
        this.isLoading = true;
        this.pageNumber = this.pageNumber - 1;
        this.handleLoad();
    }

    handleFirst() {
        this.isLoading = true;
        this.pageNumber = 1;
        this.handleLoad();
    }

    handleLast() {
        this.isLoading = true;
        this.pageNumber = this.pageCount;
        this.handleLoad();
    }
}