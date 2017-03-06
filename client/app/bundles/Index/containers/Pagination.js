import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import { encode } from 'querystring'
import clone from 'lodash/clone'
import merge from 'lodash/merge'
import range from 'lodash/range'
import Pagination from '../components/Pagination'

const mapStateToProps = (state, ownProps) => {
  const resultData = state.ajax.indexResults
  const pages = range(1, resultData.meta.total_pages + 1)
  const current_page = resultData.meta.current_page

  // Remove the /api/v1 part from links to make it a ui route
  let previousPageHref = resultData.links.previous || ''
  if (previousPageHref) previousPageHref = previousPageHref.substr(7)
  let nextPageHref = resultData.links.next || ''
  if (nextPageHref) nextPageHref = nextPageHref.substr(7)

  return {
    pages,
    previousPageHref,
    nextPageHref,
    current_page
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  myClick(event) {
    var page = null;
    while (stateProps.pages[page-1] == null) {
      page = prompt("Springe zu 1-"+stateProps.pages.length+":", stateProps.current_page);
    }
    const params = merge(clone(ownProps.params), { page: page })
    const href = `/${ownProps.model}?${encode(params)}`
    browserHistory.push(href)
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Pagination)
