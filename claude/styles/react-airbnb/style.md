# Quick Style Reference - React Airbnb

## Core Rules
- Functional components with hooks
- One component per file
- .jsx extension for React components
- Named exports for components

## Naming
- PascalCase: Components (UserProfile)
- camelCase: functions, variables, props
- SCREAMING_SNAKE_CASE: constants
- Prefix hooks with 'use' (useAuth)
- Event handlers: handle* (handleClick)

## Component Structure
```jsx
import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';

export function ComponentName({ prop1, prop2 }) {
  // State
  const [state, setState] = useState(null);
  
  // Effects
  useEffect(() => {
    // effect
  }, [dependency]);
  
  // Handlers
  const handleClick = () => {
    // handle
  };
  
  // Render
  return (
    <div>
      {/* JSX */}
    </div>
  );
}

ComponentName.propTypes = {
  prop1: PropTypes.string.isRequired,
  prop2: PropTypes.number,
};

ComponentName.defaultProps = {
  prop2: 0,
};
```

## JSX Rules
- Self-close tags without children
- Quotes for JSX attributes
- Parentheses for multiline JSX
- Explicit boolean props