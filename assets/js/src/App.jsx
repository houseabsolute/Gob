import React from 'react';
import ReactDOM from 'react-dom';
import {Nav, NavItem} from 'react-bootstrap';
import {PostingForm} from 'components/PostingForm';

function App(props) {
    return (
        <Grid>
          <Row>
            <Col md={12}>
              <Nav bsStyle="tabs" activeKey="1">
                <NavItem href="/postings">My Postings</NavItem>
                <NavItem href="/posting/new_form">New Posting</NavItem>
              </Nav>
            </Col>
          </Row>
          <Row>
            <Col md={12}>
              <PostingForm />
            </Col>
          </Row>
        </Grid>
    );
}

ReactDOM.render(
    <App />,
    document.getElementById('root')
);
