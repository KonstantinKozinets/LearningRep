import { LightningElement, track } from 'lwc';
import getAccountList from '@salesforce/apex/AccountFieldSet.getAccountList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountPage extends LightningElement {

    @track accFields;
    @track accData;
    @track pageSize;

    isLoading;
    isSized = false;
    isAccountCreate;
    isAccounts;

    selectedAccountId;
    pageNumber = 1;
    pageCount = 0;

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

    get validatePageSize() {
        return (this.pageSize && this.pageSize <= 50 && this.pageSize >= 2)
    }

    get validateSizeBut() {
        return !this.validatePageSize;
    }

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

    handleLoad () {
        getAccountList({pageNumber: this.pageNumber, pageSize: this.pageSize})
            .then(result => {
                this.isSized = true;
                this.accData = result;
                this.isAccounts = true;
                this.isAccountCreate = false;
                this.pageNumber = result.pageNumber;
                this.pageCount = result.pageCount;
                this.accFields = result.accFields;
                this.isLoading = false;
            })
            .catch(error => {
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

    handleChangeSize(event){
        this.pageSize = event.target.value;
     }

    handleReSize() {
        this.isSized = false;
        this.accData = false;
    }
}