import { LightningElement, api, track } from 'lwc';


export default class AccountsTable extends LightningElement {
    @track error;
    @track nAccounts;
    @track fields;

    @api
    get accounts() {
        return this.nAccounts;
    }

    set accounts(value) {
        this.nAccounts = value && value.accounts && value.fieldSet ? this.prepareRecords(value) : [];
        this.fields = value && value.fieldSet ? value.fieldSet : [];
    }

    handleAccountSelect(evt) {
        const event = new CustomEvent('accountselected', {
            detail: evt.target.getAttribute("data-view-id")
        });

        this.dispatchEvent(event);
    }

    prepareRecords(newAccounts) {
        return newAccounts.accounts.map((account, Index) => ({
            ...account,
            Index,
            dataTableValue: newAccounts.fieldSet.map((field, fieldName) => this.changeRecordValues(
                account, field.fieldName, field.type, fieldName
            ))
        }));
    }

    changeRecordValues(account, fieldName, type, index) {
        return {
            key: index,
            value: account[fieldName],
            type,
            fieldName,
            isDateTimeType: type === 'datetime',
            isDateType: type === 'date',
            isPhoneType: type === 'phone',
            isEmailType: type === 'email',
            isViewAction: fieldName === 'Name',
            isCommonView: type !== 'datetime' &&
                        fieldName !== 'Name' &&
                        type !== 'date'&&
                        type !== 'email' &&
                        type !== 'phone'
        };
    }
}