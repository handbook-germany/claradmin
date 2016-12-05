import React, { PropTypes, Component } from 'react'
import { Form, InputSet, Button } from 'rform'
import EditTranslationRow from '../containers/EditTranslationRow'

export default class EditTranslationForm extends Component {
  render() {
    const {
      seedData, action, formObjectClass, source, properties, formId,
      handleResponse, afterResponse, may_edit
    } = this.props

    return (
      <Form ajax requireValid
        method='PATCH' action={action}
        id={formId} seedData={seedData} formObjectClass={formObjectClass}
        handleResponse={handleResponse} afterResponse={afterResponse}
      >
        <fieldset>
          <table className="table table-condensed offer-translations--form-table">
            <tbody>
              <tr>
                <th className='translation'>
                  Übersetzung von {this.renderTranslationSource()}
                </th>
                <th className='original'>
                  Original {/*TODO: Link to edit*/}
                </th>
              </tr>
              {properties.map(property => {
                return(
                  <EditTranslationRow
                    key={property} property={property} formId={formId}
                    source={source} may_edit={may_edit}
                  />
                )
              })}
            </tbody>
          </table>
        </fieldset>
        {this.renderButtonOrText()}
      </Form>
    )
  }

  renderButtonOrText() {
    if (this.props.may_edit) {
      return(
        <Button
          className='btn btn-primary'
          disableOnInvalid disableOnUnchanged
          label='Speichern' unchangedDisabledLabel='Gespeichert!'
          invalidDisabledLabel='Es existieren Formular-Fehler!'
        />
      )
    } else {
      return <span className='text-danger'>Du bist nicht zugewiesen!</span>
    }
  }

  renderTranslationSource() {
    if (this.props.translation.source == 'GoogleTranslate') {
      return <span className='text-danger'>GoogleTranslate</span>
    }
    else if (this.props.translation.possibly_outdated) {
      return(
        <span className='text-warning'>
          Menschenhand
          <dfn title='möglicherweise veraltet'>*</dfn>
        </span>
      )
    }
    else {
      return <span className='text-success'>Menschenhand</span>
    }
  }
}
