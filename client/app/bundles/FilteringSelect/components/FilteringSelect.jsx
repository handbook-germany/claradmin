import React, { PropTypes } from 'react'
import { Label, Input, Errors } from 'rform'
import VirtualizedSelect from 'react-virtualized-select'

export default class FilteringSelect extends React.Component {
  componentDidMount() {
    this.props.onMount()

    if (!!this.props.value) {
      this.props.onFirstValue(this.props.value)
    }
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.value === undefined && !!nextProps.value) {
      this.props.onFirstValue(nextProps.value)
    }
  }

  render() {
    const {
      wrapperClassName, attribute, errorClassName, errors, label, loadOptions,
      onChange, value, multi, placeholder, children,
      options, isLoading, onInputChange, showSelect, formId, model,
    } = this.props

    return (
      <div className={wrapperClassName}>
        <Label
          formId={formId} model={model || 'generic'} attribute={attribute}
          content={label}
        />

        {showSelect && this._renderSelect(
          multi, options, isLoading, onChange, onInputChange, value, placeholder
        )}

        {children}

        <Errors
          className={errorClassName} attribute={attribute} errors={errors}
        />
      </div>
    )
  }

  _renderSelect(
    multi, options, isLoading, onChange, onInputChange, value, placeholder
  ) {
    return(
      <VirtualizedSelect multi={multi}
        options={options} isLoading={isLoading} onChange={onChange}
        onInputChange={onInputChange} value={value}
        placeholder={placeholder}
      />
    )
  }
}
