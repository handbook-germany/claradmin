import React, { PropTypes, Component } from 'react'
import { Form, InputSet} from 'rform'
import ActionUpdateFormObject from '../forms/ActionUpdateFormObject'
import AssignmentFormObject from '../../NewAssignment/forms/AssignmentFormObject'

export default class AssignmentActions extends Component {

  render() {
    const {
      assignment, actions
    } = this.props

    return (
      <div className='content AssignmentActions'>
        {actions.map(action => {
          if(action.method == 'PATCH'){
            return this.renderUpdateForm(action)
          } else {
            return this.renderCreateForm(action)
          }
        })}
      </div>
    )
  }

  renderUpdateForm(action) {
    const { handleResponse, afterResponse } = this.props

    return(
      <Form ajax requireValid seedData={action.seedData} id={action.formId}
        method={action.method} action={action.href} className='form-inline'
        key={action.formId} formObjectClass={ActionUpdateFormObject}
        handleResponse={handleResponse} afterResponse={afterResponse}
      >
        <hr />
        <button type='submit' className='btn btn-warning'>
          {action.buttonText}
        </button>
      </Form>
    )
  }

  renderCreateForm(action) {
    const { handleResponse, afterResponse, users } = this.props

    const optionalUserSelection = action.userChoice ?
      <InputSet
        wrapperClassName='form-group' className='form-control'
        label='an' type='select' attribute='reciever_id' options={users}
      /> : null

    return(
      <Form ajax requireValid seedData={action.seedData} id={action.formId}
        method={action.method} action={action.href} className='form-inline'
        key={action.formId} formObjectClass={AssignmentFormObject}
        handleResponse={handleResponse} afterResponse={afterResponse}
      >
        <hr />
        <InputSet
          wrapperClassName='form-group' className='form-control'
          wrapperErrorClassName='has-error' errorClassName='help-block'
          label='Nachricht' type='textfield' attribute='message'
          placeholder='Gib eine Nachricht ein'
        />
        {optionalUserSelection}
        <button type='submit' className='btn btn-warning'>
          {action.buttonText}
        </button>
      </Form>
    )
  }
}
