import React from 'react';
import {PostingForm} from 'components/PostingForm';

class PostingForm extends React.Component {
    constructor(props) {
        super(props);

        this.handleSubmit = this.handleSubmit.bind(this);
    }

    handleSubmit(e) { }

    render() {
        return (
          <form onSubmit={this.handleSubmit}>
            <h1>Create a Posting</h1>
            <FieldGroup id="title" type="text" label="Title" placeholder="Position Title" />
            <FieldGroup id="description" type="textarea" label="Description" placeholder="Position Description" />
            <Button type="submit">Submit</Button>
          </form>
        );
    }
}
