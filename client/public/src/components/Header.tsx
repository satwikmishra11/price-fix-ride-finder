
import React from 'react';
import Logo from '../assets/logo';

const Header = () => {
  return (
    <header className="w-full px-4 py-4 flex items-center justify-between bg-white border-b">
      <Logo />
      <button className="p-2 rounded-full hover:bg-gray-100 transition-colors">
        <svg 
          xmlns="http://www.w3.org/2000/svg" 
          width="24" 
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor" 
          strokeWidth="2" 
          strokeLinecap="round" 
          strokeLinejoin="round"
        >
          <line x1="4" x2="20" y1="12" y2="12"/>
          <line x1="4" x2="20" y1="6" y2="6"/>
          <line x1="4" x2="20" y1="18" y2="18"/>
        </svg>
      </button>
    </header>
  );
};

export default Header;
