import { LightningElement, wire } from 'lwc';
import LAST_NAME_FIELD from '@salesforce/schema/Contact.LastName';
import FIRST_NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import getContacts from '@salesforce/apex/ContactController.getContacts';

const COLUMNS = [
    { label: 'Contact First Name', fieldName: FIRST_NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Contact Last Name', fieldName: LAST_NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Email', fieldName: EMAIL_FIELD.fieldApiName, type: 'email' }
];

export default class ContactList extends LightningElement {
    columns = COLUMNS;
    @wire(getContacts) contacts;
}