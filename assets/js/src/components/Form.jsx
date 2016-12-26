import React from 'react';
import { Button, Col, ControlLabel, FormControl, FormGroup, Grid, Row } from 'react-bootstrap';

class FieldGroup extends React.Component {
    constructor(props) {
        super(props);

        this.state = { value: '' };
        this.handleChange = this.handleChange.bind(this);
    }

    handleChange(e) {
        this.setState({ value: e.target.value });
    }

    render() {
        return (
          <FormGroup controlId={this.props.id}>
            <ControlLabel>{this.props.label}</ControlLabel>
            <FormControl
              type={this.props.type}
              placeholder={this.props.placeholder}
              value={this.state.value}
              onChange={this.handleChange}
            />
          </FormGroup>
        );
    }
}
